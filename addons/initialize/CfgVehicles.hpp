class CfgVehicles {
    class ModuleHvtObjectivesInstance_F;
    class GVAR(ModuleHvtObjectivesInstance): ModuleHvtObjectivesInstance_F {
        author = "[A] Salbei";
        _generalMacro = QGVAR(ModuleHvtObjectivesInstance);
        displayName = "GRAD EndGame Objectives Instance";
		function = QUOTE(FUNC(setModule));
        category = "Objectives";
    };

    class ModuleHvtSimpleObjective_F;
    class GVAR(ModuleHvtSimpleObjective): ModuleHvtSimpleObjective_F {
        author = "[A] Salbei";
        _generalMacro = QGVAR(ModuleHvtSimpleObjective);
        displayName = "GRAD End Game Simple Objective";
		function = QUOTE(FUNC(setModule));
        category = "Objectives";
    };

    class ModuleHvtStartGameObjective_F;
    class GVAR(ModuleHvtStartGameObjective): ModuleHvtStartGameObjective_F {
        author = "[A] Salbei";
        _generalMacro = QGVAR(ModuleHvtStartGameObjective);
        displayName = "GRAD End Game Start Game Objective";
		function = QUOTE(FUNC(setModule));
        category = "Objectives";
    };

    class ModuleHvtEndGameObjective_F;
    class GVAR(ModuleHvtEndGameObjective): ModuleHvtEndGameObjective_F {
        author = "[A] Salbei";
        _generalMacro = QGVAR(ModuleHvtEndGameObjective);
        displayName = "GRAD End Game - End Game Objective";
		function = QUOTE(FUNC(setModule));
        category = "Objectives";
    };

    delete ModuleHvtEndGameObjective_F;
};