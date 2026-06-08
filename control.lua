local function grant_stack(player, item_name, stacks)
  local item_proto = prototypes.item[item_name]
  if not item_proto then
    return false
  end

  if stacks <= 0 then
    return false
  end

  local stack_size = item_proto.stack_size or 50
  local count = math.floor((stack_size * stacks) + 0.5)
  if count <= 0 then
    return false
  end

  player.insert({
    name = item_name,
    count = count
  })
  return true
end

local function grant_quickstart(player)
  if not player then
    return
  end

  grant_stack(player, "requester-chest", 1)
  grant_stack(player, "passive-provider-chest", 1)
  grant_stack(player, "storage-chest", 1)
  grant_stack(player, "active-provider-chest", 1)
  grant_stack(player, "buffer-chest", 1)

  grant_stack(player, "angels-cargo-robot", 1)
  grant_stack(player, "roboport", 1)

  grant_stack(player, "electric-mining-drill", 1)
  grant_stack(player, "assembling-machine-1", 1)
  grant_stack(player, "stone-furnace", 1)

  grant_stack(player, "angels-burner-ore-crusher", 1)
  grant_stack(player, "inserter", 4)
  grant_stack(player, "bob-basic-transport-belt", 10)
  grant_stack(player, "bob-basic-underground-belt", 5)
  grant_stack(player, "bob-basic-splitter", 2)

  grant_stack(player, "boiler", 0.4)
  grant_stack(player, "steam-engine", 4)
  grant_stack(player, "offshore-pump", 0.05)
  grant_stack(player, "bob-copper-pipe", 1)
  grant_stack(player, "bob-copper-pipe-to-ground", 2)

  grant_stack(player, "small-electric-pole", 4)
  grant_stack(player, "coal", 8)
end

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)
  grant_quickstart(player)
end)

commands.add_command("local-quickstart", "Grant Local Quickstart starter items to your character.", function(command)
  local player = game.get_player(command.player_index)
  if not player then
    return
  end

  grant_quickstart(player)
  player.print("Local Quickstart kit granted.")
end)

commands.add_command("grant-chests", "Grant one full stack of each logistics chest type.", function(command)
  local player = game.get_player(command.player_index)
  if not player then
    return
  end
  grant_stack(player, "requester-chest", 1)
  grant_stack(player, "passive-provider-chest", 1)
  grant_stack(player, "storage-chest", 1)
  grant_stack(player, "active-provider-chest", 1)
  grant_stack(player, "buffer-chest", 1)
end)

commands.add_command("grant-robots", "Grant one full stack of Angels logistics robots.", function(command)
  local player = game.get_player(command.player_index)
  if not player then
    return
  end
  grant_stack(player, "angels-cargo-robot", 1)
end)

commands.add_command("grant-ports", "Grant one full stack of Angels logistics robots.", function(command)
  local player = game.get_player(command.player_index)
  if not player then
    return
  end
  grant_stack(player, "roboport", 1)
end)
