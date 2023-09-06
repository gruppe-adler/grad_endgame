if (!isNil { BIS_hvt_pickupInfo }) then
{
	if (!isNull (BIS_hvt_pickupInfo select 0)) then
	{
		#define PICKUP_UPLOAD_DISTANCE 3.5

		params [["_target", objNull, [objNull]], ["_player", objNull, [objNull]]];

		private ["_pickup", "_side"];
		_pickup = BIS_hvt_pickupInfo select 0;
		_side 	= side group _player;

		private "_isNear";
		_isNear	= eyePos _player distance getPosASL _pickup <= PICKUP_UPLOAD_DISTANCE;

		if (_isNear) then
		{
			private ["_isLockedFrom", "_needsPickup", "_isUploading", "_isIncapacitated"];
			_isLockedFrom		= (BIS_hvt_pickupInfo select 3) != _side && (BIS_hvt_pickupInfo select 3) != sideUnknown;
			_needsPickup		= BIS_hvt_pickupInfo select 2 == "NeedsPickup";
			_isUploading		= BIS_hvt_pickupInfo select 2 == "Uploading";
			_isIncapacitated	= _player getVariable ["BIS_revive_incapacitated", false];

			!_isLockedFrom && (_needsPickup || _isUploading) && !_isIncapacitated && _target == _player;
		}
		else
		{
			false;
		};
	}
	else
	{
		false;
	};
}
else
{
	false;
};