local M = {}

local wezterm = require("wezterm")
local act = wezterm.action

local function map(table, func)
  local result = {}
  for key, value in pairs(table) do
    result[key] = func(value, key)
  end
  return result
end

local function gen_fixed_send_key(key)
  return {
    key = key,
    mods = 'SHIFT',
    action = act.SendKey {
      key = key, mods = 'SHIFT'
    }
  }
end

local function utf8_chars(string)
  local result = {}
  for _, code in utf8.codes(string) do
    result[#result + 1] = utf8.char(code)
  end
  return result
end

function M.apply_to_config(config)
  local char_table = utf8_chars('ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ')

  config.key_tables.nu_hack = map(char_table, gen_fixed_send_key)
  -- else
  --   config.key_tables = { nu_hack = map(char_table, gen_fixed_send_key) }
  -- end

  wezterm.on('update-status', function(window, pane)
    local active_key_table = window:active_key_table()
    local fg_proc_name = pane:get_foreground_process_info().name

    if fg_proc_name == "nu" and active_key_table ~= "nu_hack" then
      window:perform_action(
        act.ActivateKeyTable {
          name = 'nu_hack',
          one_shot = false,
        },
        pane
      )
    elseif fg_proc_name ~= "nu" and active_key_table == "nu_hack" then
      window:perform_action(
        act.PopKeyTable,
        pane
      )
    end
  end)
end

return M
