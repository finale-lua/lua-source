# lua-source

This repository contains all the Lua and Lua-related source code used by the _RGP Lua_ plugin for Finale. The goal has been to keep it as close as possible to the source code provided by the [Lua Organization](https://www.lua.org/). However a few very minor tweaks have been required, and this repository tracks them. This repository may be very useful if you are creating or building a C/C++ library for use with Lua on Finale and you wish to embed the Lua source code.

The following are included:

- XCode and Visual Studio project files for building static libraries of the Lua language and `luasocket`. (These are the same project files used by _RGP Lua_.)
- A submodule link for `luasocket`.
- A back-ported version of the `utf8` library (from Lua 5.3) for use with Lua 5.2.
- Lua source code (downloaded from the Lua Organization) for Lua 5.2, 5.3, and 5.4. Only Lua 5.2 is used by _RGP Lua_ (plus a copy of `lutf8lib.c` originally taken from 5.3). The other versions are there for reference only.
- The built-in Lua functions provided by _RGP Lua_ and _JW Lua_ to all scripts. These are mainly iterator functions such as `each`, `eachentry`, `eachentrysaved`, etc.

Generally speaking, Pull Requests will not be accepted. But if you have an issue, please feel free to raise it.
