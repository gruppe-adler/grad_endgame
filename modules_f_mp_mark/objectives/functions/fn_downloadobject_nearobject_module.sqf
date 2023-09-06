#include "\a3\modules_f_mp_mark\objectives\defines.inc"

private _nearObjects = nearestObjects [positionCameraToWorld [0,0,0], [], 100];
private _downloadableObject = objNull;

{
	if (_x getVariable [VAR_DOWNLOADABLE, false] && { !(side group player in (_x getVariable [VAR_DOWNLOADED_BY, []])) }) exitWith
	{
		_downloadableObject = _x;
	};
}
forEach _nearObjects;

_downloadableObject;
