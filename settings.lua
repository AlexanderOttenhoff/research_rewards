data:extend({
  {
    type = "bool-setting",
    name = "research-rewards-show-message",
    setting_type = "runtime-per-user",
    default_value = true,
    order = "a",
  },
  {
    type = "bool-setting",
    name = "research-rewards-grant-non-placeable",
    setting_type = "runtime-global",
    default_value = true,
    order = "b",
  },
  {
    type = "bool-setting",
    name = "research-rewards-grant-non-hand-craftable",
    setting_type = "runtime-global",
    default_value = true,
    order = "c",
  },
  {
    type = "bool-setting",
    name = "research-rewards-grant-liquids",
    setting_type = "runtime-global",
    default_value = false,
    order = "d",
  },
  {
    type = "int-setting",
    name = "research-rewards-stack-fraction",
    setting_type = "runtime-global",
    default_value = 100,
    minimum_value = 1,
    order = "e",
  },
})
