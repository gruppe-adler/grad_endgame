// Disable save game
enableSaving [false, false];

// Disable remote sensores
disableRemoteSensors true;

// Server init
if (isServer) then
{
	[] execVM "a3\modules_f_mp_mark\objectives\scripts\initServer.sqf";
};

// Client init
if (hasInterface) then
{
	private _isSpectator = typeOf player == "VirtualSpectator_F" || { side group player == sideLogic };

	if (_isSpectator) then
	{
		[] execVM "a3\Modules_F_MP_Mark\Objectives\scripts\initPlayerSpectator.sqf";
	}
	else
	{
		[] execVM "a3\modules_f_mp_mark\objectives\scripts\initPlayerLocal.sqf";
	};
};