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

# Why letters interprets wrong?
If you try check key events in nushell, you can see, that wezterm makes right in case of unicode character, from point of kitty [keyboard-protocol](https://sw.kovidgoyal.net/kitty/keyboard-protocol/#:~:text=a%2E-,Note,u%2E,-If) side, but not from point side of nushell (even with `config.use_kitty_protocol = true`)
```
[17:42]  nu❯ keybindings listen
Type any key combination to see key details. Press ESC to abort.
char: ф, code: 0x000444, modifier: KeyModifiers(0x0), flags: 0b000000, kind: Press, state: KeyEventState(0x0)
char: ф, code: 0x000444, modifier: KeyModifiers(SHIFT), flags: 0b000001, kind: Press, state: KeyEventState(NUM_LOCK)
char: a, code: 0x000061, modifier: KeyModifiers(0x0), flags: 0b000000, kind: Press, state: KeyEventState(0x0)
char: A, code: 0x000041, modifier: KeyModifiers(SHIFT), flags: 0b000001, kind: Press, state: KeyEventState(0x0)
```
But nushell (and i think lots of software) don't care about it. And awaits and KeyModifier and uppercase character code.

So if we remap keys to uppercase versions, nushell start read it as uppercase letters input
```
[17:40]  nu❯ keybindings listen
Type any key combination to see key details. Press ESC to abort.
char: ф, code: 0x000444, modifier: KeyModifiers(0x0), flags: 0b000000, kind: Press, state: KeyEventState(0x0)
char: Ф, code: 0x000424, modifier: KeyModifiers(SHIFT), flags: 0b000001, kind: Press, state: KeyEventState(0x0)
char: a, code: 0x000061, modifier: KeyModifiers(0x0), flags: 0b000000, kind: Press, state: KeyEventState(0x0)
char: A, code: 0x000041, modifier: KeyModifiers(SHIFT), flags: 0b000001, kind: Press, state: KeyEventState(0x0)
```
