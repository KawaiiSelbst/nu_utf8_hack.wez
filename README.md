Fix for nushell (or wezterm) wrong interpretation of unicode char + shift chars through kitty protocol

## Usage

Add to your config

```lua
local nu_utf8_hack = wezterm.plugin.require 'https://github.com/KawaiiSelbst/nu_utf8_hack.wez'

-- char_table - characters that need to be uppered with SHIFT while typing
local nu_utf8_hackConfig = { char_table = "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ" }

nu_utf8_hack.apply_to_config(config, nu_utf8_hackConfig)
```

