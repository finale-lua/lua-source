# lua-source

This repository contains all the Lua and Lua-related source code used by the _RGP Lua_ plugin for Finale. The goal has been to keep it as close as possible to the source code provided by the [Lua Organization](https://www.lua.org/). However a few very minor tweaks have been required, and this repository tracks them. This repository may be very useful if you are creating or building a C/C++ library for use with Lua on Finale and you wish to embed the Lua source code.

The following are included:

- XCode and Visual Studio project files for building static libraries of the Lua language and other embedded C libraries. (These are the same project files used by _RGP Lua_.)
- Submodule links for other open-source projects embedded in _RGP Lua_. These include `luasocket`, `luafilesystem`, and `lua-cjson`.
- _RGP Lua_ currently uses `LuaBridge3` to interface with the [PDK Framework](https://pdk.finalelua.com/). _JW Lua_ uses an older version of `LuaBridge2`.
- A back-ported version of the `utf8` library (from Lua 5.4) for use with Lua 5.2.
- Lua source code (downloaded from the Lua Organization) for Lua 5.2, 5.3, and 5.4. Only Lua 5.4 is currently used by _RGP Lua_. The other versions are there for reference only.
- The built-in Lua functions provided by _RGP Lua_ and _JW Lua_ to all scripts. These are mainly iterator functions such as `each`, `eachentry`, `eachentrysaved`, etc.

Generally speaking, pull requests will not be accepted. But if you have an issue, please feel free to raise it.
