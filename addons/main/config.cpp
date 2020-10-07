#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(ADDON);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {};
        authors[] = {"Ainer", "Salbei"};
        VERSION_CONFIG;
    };
};

#include <CfgSettings.hpp>
