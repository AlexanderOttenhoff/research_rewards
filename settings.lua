data:extend({
  {
    type = "bool-setting",
    name = "research-reward-stacks-show-message",
    setting_type = "runtime-per-user",
    default_value = true,
    order = "a",
  },
  {
    type = "bool-setting",
    name = "research-reward-stacks-grant-non-placeable",
    setting_type = "runtime-global",
    default_value = true,
    order = "b",
  },
  {
    type = "bool-setting",
    name = "research-reward-stacks-grant-non-hand-craftable",
    setting_type = "runtime-global",
    default_value = false,
    order = "c",
  },
  {
    type = "bool-setting",
    name = "research-reward-stacks-grant-liquids",
    setting_type = "runtime-global",
    default_value = false,
    order = "d",
  },
})
