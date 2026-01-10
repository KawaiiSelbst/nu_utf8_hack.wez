# Desctiption
Fix for nushell (or wezterm) wrong interpretation of unicode letters + shift chars through kitty protocol (in my case is uppercase Russian letters)

# Usage
Add to your config
```lua
local nu_utf8_hack = wezterm.plugin.require 'https://github.com/KawaiiSelbst/nu_utf8_hack.wez'

-- char_table - characters that need to be uppered with SHIFT while typing
local nu_utf8_hackConfig = { char_table = "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ" }

nu_utf8_hack.apply_to_config(config, nu_utf8_hackConfig)
```

# How it works? 
It registers key_table, with remaps all keys from `char_table` in favor of
```lua
key = <Letter>,
mods = 'SHIFT',
action = act.SendKey {
   key = <Letter>, mods = 'SHIFT'
}
```
and adds callback to event status_update, and check if foreground process name of pane is `nu`, and if then enables key_table with remap, and disable it if foreground process name isn's `nu`
