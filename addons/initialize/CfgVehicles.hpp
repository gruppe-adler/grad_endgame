class CfgVehicles {
    class ModuleHvtObjectivesInstance_F;
    class GVAR(ModuleHvtObjectivesInstance): ModuleHvtObjectivesInstance_F {
        author = "[A] Salbei";
        _generalMacro = QGVAR(ModuleHvtObjectivesInstance);
        displayName = "GRAD Objectives Instance";
		function = QUOTE(FUNC(setModule));
        category = "Objectives";
    };

    class ModuleHvtSimpleObjective_F;
    class GVAR(ModuleHvtSimpleObjective): ModuleHvtSimpleObjective_F {
        author = "[A] Salbei";
        _generalMacro = QGVAR(ModuleHvtSimpleObjective);
        displayName = "GRAD Simple Objective";
		function = QUOTE(FUNC(setModule));
        category = "Objectives";
    };

    class ModuleHvtStartGameObjective_F;
    class GVAR(ModuleHvtStartGameObjective): ModuleHvtStartGameObjective_F {
        author = "[A] Salbei";
        _generalMacro = QGVAR(ModuleHvtStartGameObjective);
        displayName = "GRAD Start Game Objective";
		function = QUOTE(FUNC(setModule));
        category = "Objectives";
    };

    class ModuleHvtEndGameObjective_F;
    class GVAR(ModuleHvtEndGameObjective): ModuleHvtEndGameObjective_F {
        author = "[A] Salbei";
        _generalMacro = QGVAR(ModuleHvtEndGameObjective);
        displayName = "GRAD Objective";
		function = QUOTE(FUNC(setModule));
        category = "Objectives";
    };

    class ModuleHvtObjectiveRandomiser_F;
    class GVAR(ModuleHvtObjectiveRandomiser): ModuleHvtObjectiveRandomiser_F {
        author = "[A] Salbei";
        _generalMacro = QGVAR(ModuleHvtObjectiveRandomiser);
        displayName = "GRAD Objective Randomizer";
		function = QUOTE(FUNC(setModule));
    };
};