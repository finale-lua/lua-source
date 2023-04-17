//
//  loadlib-restricted.h
//  RGPLua
//
//  Created by Robert Patterson on 4/17/23.
//

#ifndef loadlib_restricted_h
#define loadlib_restricted_h

#ifdef __cplusplus
extern "C" {
#endif

LUAMOD_API int luaopen_package_restricted (lua_State *L);

#ifdef __cplusplus
}
#endif

#endif /* loadlib_restricted_h */
