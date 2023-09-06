if (!isNil { BIS_hvt_pickupInfo }) then
{
	if (!isNull (BIS_hvt_pickupInfo select 0)) then
	{
		#define PICKUP_UPLOAD_DISTANCE 3.5

		params [["_target", objNull, [objNull]], ["_player", objNull, [objNull]]];

		if (!isNull _player) then
		{
			private "_side";
			_side = side group _player;

			private "_sideIndex";
			_sideIndex = switch (_side) do
			{
				case WEST : 	{ 0 };
				case EAST : 	{ 1 };
				case DEFAULT 	{ -1 };
			};

			private "_upload";
			_upload = if (_sideIndex == -1) then
			{
				objNull;
			}
			else
			{
				(BIS_hvt_pickupInfo select 4) select _sideIndex;
			};

			if (!isNull _upload) then
			{
				private "_isNear";
				_isNear	= _player distance _upload <= PICKUP_UPLOAD_DISTANCE;

				if (_isNear) then
				{
					private ["_onCarrier", "_isCarrier", "_isIncapacitated", "_isRightUpload"];
					_onCarrier 		= BIS_hvt_pickupInfo select 2 == "OnCarrier";
					_isCarrier 		= _player == (BIS_hvt_pickupInfo select 1) select 0;
					_isIncapacitated	= _player getVariable ["BIS_revive_incapacitated", false];
					_isRightUpload		= _target getVariable ["BIS_hvt_downloadableOwnerSide", civilian] == _side;

					_onCarrier && _isCarrier && !_isIncapacitated && _isRightUpload;
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