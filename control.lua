---@param item_proto LuaItemPrototype
---@return boolean
local function is_placeable(item_proto)
  return item_proto.place_result ~= nil or item_proto.place_as_tile_result ~= nil
end

-- Returns true if any of the recipes producing this item are hand-craftable
-- (i.e. use the "crafting" category, which the player inventory can perform).
---@param item_name string
---@param force LuaForce
---@return boolean
local function is_hand_craftable(item_name, force)
  for _, recipe in pairs(force.recipes) do
    if recipe.enabled and recipe.prototype.category == "crafting" then
      for _, product in pairs(recipe.products) do
        if product.type == "item" and product.name == item_name then
          return true
        end
      end
    end
  end
  return false
end

-- For a fluid, find the item(s) used to store it.
-- Returns a table of item names that can hold this fluid.
---@param fluid_name string
---@return table<string, boolean>
local function find_containers_for_fluid(fluid_name)
  local containers = {}

  -- Vanilla: barrels are named "[fluid-name]-barrel"
  local barrel_name = fluid_name .. "-barrel"
  if prototypes.item[barrel_name] then
    containers[barrel_name] = true
  end

  -- Angels petrochem: fluid and its container item share the same name
  -- e.g. fluid "angels-gas-hydrogen" -> item "angels-gas-hydrogen" (gas canister)
  --      fluid "angels-liquid-hydrofluoric-acid" -> item "angels-liquid-hydrofluoric-acid"
  -- Only add if not already found as a barrel and the item actually exists
  if not containers[fluid_name] and prototypes.item[fluid_name] then
    containers[fluid_name] = true
  end

  return containers
end

---@class NewlyCraftable
---@field items table<string, boolean>
---@field fluids table<string, boolean>

---@param technology LuaTechnology
---@return NewlyCraftable
local function get_newly_craftable(technology)
  local items = {}
  local fluids = {}
  local force = technology.force
  local tech_proto = technology.prototype

  for _, effect in pairs(tech_proto.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe then
      local recipe = force.recipes[effect.recipe]
      if recipe then
        for _, product in pairs(recipe.products) do
          if product.type == "item" then
            items[product.name] = true
          elseif product.type == "fluid" then
            fluids[product.name] = true
          end
        end
      end
    end
  end

  return { items = items, fluids = fluids }
end

---@param event EventData.on_research_finished
local function grant_research_rewards(event)
  local technology = event.research
  if not technology then
    return
  end

  local newly_craftable = get_newly_craftable(technology)
  local grant_non_placeable = settings.global["research-rewards-grant-non-placeable"].value
  local grant_non_hand_craftable = settings.global["research-rewards-grant-non-hand-craftable"].value
  local grant_liquids = settings.global["research-rewards-grant-liquids"].value
  local stack_fraction = settings.global["research-rewards-stack-fraction"].value / 100

  local item_entries = {}
  for item_name, _ in pairs(newly_craftable.items) do
    local item_proto = prototypes.item[item_name]
    if item_proto then
      local placeable = is_placeable(item_proto)
      local hand_craftable = is_hand_craftable(item_name, technology.force)

      if (grant_non_placeable or placeable) and (grant_non_hand_craftable or hand_craftable) then
        local stack_size = math.max(1, math.floor((item_proto.stack_size or 50) * stack_fraction))
        table.insert(item_entries, { name = item_name, proto = item_proto, stack_size = stack_size })
      end
    end
  end

  if grant_liquids then
    for fluid_name, _ in pairs(newly_craftable.fluids) do
      local containers = find_containers_for_fluid(fluid_name)
      for container_name, _ in pairs(containers) do
        local item_proto = prototypes.item[container_name]
        if item_proto then
          local stack_size = math.max(1, math.floor((item_proto.stack_size or 50) * stack_fraction))
          table.insert(item_entries, { name = container_name, proto = item_proto, stack_size = stack_size })
        end
      end
    end
  end

  if #item_entries == 0 then
    return
  end

  for _, player in pairs(technology.force.players) do
    if player and player.valid then
      for _, entry in pairs(item_entries) do
        player.insert({ name = entry.name, count = entry.stack_size })
      end

      if settings.get_player_settings(player)["research-rewards-show-message"].value then
        player.print({ "", "Research reward from ", technology.localised_name, ":" })
        for _, entry in pairs(item_entries) do
          player.print({ "", "  - ", entry.proto.localised_name, " (x", entry.stack_size, ")" })
        end
      end
    end
  end
end

script.on_event(defines.events.on_research_finished, grant_research_rewards)
