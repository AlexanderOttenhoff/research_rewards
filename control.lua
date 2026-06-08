---@diagnostic disable: undefined-global

local function is_constructable_item(item_proto)
  if not item_proto then
    return false
  end

  return item_proto.place_result ~= nil or item_proto.place_as_tile_result ~= nil
end

local function get_unlocked_constructable_items(technology)
  local items = {}
  local force = technology.force

  for _, effect in pairs(technology.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe then
      local recipe = force.recipes[effect.recipe]
      if recipe then
        for _, product in pairs(recipe.products) do
          if product.type == "item" then
            local item_name = product.name
            local item_proto = game.item_prototypes[item_name]
            if is_constructable_item(item_proto) then
              items[item_name] = true
            end
          end
        end
      end
    end
  end

  return items
end

local function grant_research_rewards(event)
  local technology = event.research
  if not technology then
    return
  end

  local constructable_items = get_unlocked_constructable_items(technology)
  local granted_count = 0

  for _, player in pairs(technology.force.players) do
    if player and player.valid then
      for item_name, _ in pairs(constructable_items) do
        local item_proto = game.item_prototypes[item_name]
        if item_proto then
          local stack_size = item_proto.stack_size or 50
          player.insert({ name = item_name, count = stack_size })
          granted_count = granted_count + 1
        end
      end

      if granted_count > 0 then
        player.print("Research reward: granted full stacks of newly unlocked constructable items from " .. technology.localised_name .. ".")
      end
    end
  end
end

script.on_event(defines.events.on_research_finished, grant_research_rewards)
