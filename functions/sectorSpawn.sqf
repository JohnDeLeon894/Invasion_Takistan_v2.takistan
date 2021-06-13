//creates enemy groups and sets them to patrol or garison near their spawn marker
//[trigger, group size] call jMD_fnc_sectorSpawn

private _trigger	 = _this select 0;
private _groupSize	 = _this select 1;
hint format ['trigger: %1', _trigger];

private _markers =  EAST_POSITIONS select {(getMarkerPos _x) inArea _trigger};
hint format _markers;

{
	groupCount = groupCount + 1;
	private _groupName = format ['enemyGroup_%1', groupCount];
	_groupName = createGroup [east, false];
	private _wayPointScript = [
		"\z\lambs\addons\wp\scripts\fnc_wpPatrol.sqf",
		"\z\lambs\addons\wp\scripts\fnc_wpGarrison.sqf"
		] call BIS_fnc_selectRandom;
	private _position = getMarkerPos _x;
	[_groupName, _groupSize, RED_UNITS_ARRAY, _position] call jMD_fnc_spawnGroups;

	_groupName addWaypoint [_position, 200];
	[_groupName, (count waypoints _groupName) - 1 ] setWaypointScript _wayPointScript ;

} forEach _markers;

