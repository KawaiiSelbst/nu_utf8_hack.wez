# Description

Fix for nushell (or wezterm) wrong interpretation of unicode letters + shift chars through kitty protocol (in my case is uppercase Russian letters).

# Usage

Add to your config:

```lua
local nu_utf8_hack = wezterm.plugin.require 'https://github.com/KawaiiSelbst/nu_utf8_hack.wez'

-- char_table - characters that need to be uppered with SHIFT while typing
local nu_utf8_hackConfig = { char_table = "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ" }

nu_utf8_hack.apply_to_config(config, nu_utf8_hackConfig)
```

# How it works?

It registers a key_table that remaps all keys from `char_table` to:

```lua
key = <Letter>,
mods = 'SHIFT',
action = act.SendKey {
   key = <Letter>, mods = 'SHIFT'
}
```

It adds a callback to the `status_update` event that checks if the foreground process name of the pane is `nu`. If it is, it enables the key_table with the remap; otherwise, it disables it.

# Why letters are interpreted wrong?

If you check key events in nushell, you can see that wezterm is correct from the kitty [keyboard-protocol](https://sw.kovidgoyal.net/kitty/keyboard-protocol/#:~:text=a%2E-,Note,u%2E,-If) perspective, but not from nushell's perspective (even with `config.use_kitty_protocol = true`):

```
[17:42]  nu❯ keybindings listen
Type any key combination to see key details. Press ESC to abort.
char: ф, code: 0x000444, modifier: KeyModifiers(0x0), flags: 0b000000, kind: Press, state: KeyEventState(0x0)
char: ф, code: 0x000444, modifier: KeyModifiers(SHIFT), flags: 0b000001, kind: Press, state: KeyEventState(NUM_LOCK)
char: a, code: 0x000061, modifier: KeyModifiers(0x0), flags: 0b000000, kind: Press, state: KeyEventState(0x0)
char: A, code: 0x000041, modifier: KeyModifiers(SHIFT), flags: 0b000001, kind: Press, state: KeyEventState(0x0)
```

Nushell (and I think lots of software) doesn't care about this and expects both a KeyModifier and an uppercase character code.

So if we remap keys to uppercase versions, nushell starts reading them as uppercase letters input:

```
[17:40]  nu❯ keybindings listen
Type any key combination to see key details. Press ESC to abort.
char: ф, code: 0x000444, modifier: KeyModifiers(0x0), flags: 0b000000, kind: Press, state: KeyEventState(0x0)
char: Ф, code: 0x000424, modifier: KeyModifiers(SHIFT), flags: 0b000001, kind: Press, state: KeyEventState(0x0)
char: a, code: 0x000061, modifier: KeyModifiers(0x0), flags: 0b000000, kind: Press, state: KeyEventState(0x0)
char: A, code: 0x000041, modifier: KeyModifiers(SHIFT), flags: 0b000001, kind: Press, state: KeyEventState(0x0)
```
