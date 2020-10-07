#define COMPONENT functions
#include "\x\grad_endgame\addons\main\script_mod.hpp"
#include "\x\grad_endgame\addons\main\script_macros.hpp"

#define QUADRUPLE(var1,var2,var3,var4) var1##_##var2##_##var3##_##var4
#define FUNCF(var1,var2) QUADRUPLE(ADDON,var1,fnc,var2)

#ifndef PATHTO_SYS_4
    #define PATHTO_SYS_4(var1,var2,var3,var4) \MAINPREFIX\var1\SUBPREFIX\var2\var3\var4.sqf
#endif

#ifdef DISABLE_COMPILE_CACHE
    #define PREP_IN_FOLDER(var1,var2) QUADRUPLE(ADDON,var1,fnc,var1) = compile preProcessFileLineNumbers 'PATHTO_SYS_4(PREFIX,COMPONENT_F,var1,DOUBLES(fnc,var2))'
#else
    #define PREP_IN_FOLDER(var1,var2) ['PATHTO_SYS_4(PREFIX,COMPONENT_F,var1,DOUBLES(fnc,var2))', 'QUADRUPLE(ADDON,var1,fnc,var2)'] call SLX_XEH_COMPILE_NEW
#endif