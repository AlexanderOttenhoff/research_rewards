---@param technology LuaTechnology
---@return table<string, boolean>
local function get_newly_craftable_items(technology)
  local items = {}
  local force = technology.force
  local tech_proto = technology.prototype

  for _, effect in pairs(tech_proto.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe then
      local recipe = force.recipes[effect.recipe]
      if recipe then
        for _, product in pairs(recipe.products) do
          if product.type == "item" then
            items[product.name] = true
          end
        end
      end
    end
  end

  return items
end

---@param event EventData.on_research_finished
local function grant_research_rewards(event)
  local technology = event.research
  if not technology then
    return
  end

  local constructable_items = get_newly_craftable_items(technology)

  local item_entries = {}
  for item_name, _ in pairs(constructable_items) do
    local item_proto = prototypes.item[item_name]
    if item_proto then
      local stack_size = item_proto.stack_size or 50
      table.insert(item_entries, { name = item_name, proto = item_proto, stack_size = stack_size })
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

      player.print({ "", "Research reward from ", technology.localised_name, ":" })
      for _, entry in pairs(item_entries) do
        player.print({ "", "  - ", entry.proto.localised_name, " (x", entry.stack_size, ")" })
      end
    end
  end
end

script.on_event(defines.events.on_research_finished, grant_research_rewards)
