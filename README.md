# nvim-gehzu

**This project is still WIP. When using this, be prepared for _nothing_ to work, everything to break, your parents to disown you and your cat to run away.**

**nvim-gehzu** Is a nvim-specific implementation of go-to-definition and related functionality.
For now, it only works for fennel files, but lua support is planned in the future.

## Usage

**nvim-gehzu** currently provides two functions: `go_to_definition()` and `show_definition()`. 
These can optionally be given a symbol to resolve. If not given anything, they will jump to / show the definition of the currently hovered symbol.


Use the following functions in your keybinds:
```lua
require('nvim-gehzu').show_definition()
require('nvim-gehzu').go_to_definition()
```
