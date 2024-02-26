//
//  loadlib-restricted.h
//  RGPLua
//
//  Created by Robert Patterson on 4/17/23.
//

#ifndef loadlib_restricted_h
#define loadlib_restricted_h

#ifdef __cplusplus
// this static assert reminds us to re-implement loadlib-restricted.c each time we upgrade to a new Lua version
static_assert(LUA_VERSION_RELEASE_NUM == 50406, "wrong Lua version");
#endif

#ifdef __cplusplus
extern "C" {
#endif

LUAMOD_API int luaopen_package_restricted (lua_State *L);

#ifdef __cplusplus
}
#endif

#endif /* loadlib_restricted_h */
