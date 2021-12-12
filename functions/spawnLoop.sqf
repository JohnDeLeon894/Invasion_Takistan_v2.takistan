//This is the loop that continuously spawns soldiers until continueLoop = false

diag_log 'Spawn loop started';
if (!continueLoop) exitWith {
	hint 'loop stopped'
};
if (ONE_LOOP == true) exitWith {
	hint 'instance of loop already running'
};

ONE_LOOP = true;
//declare groups to count

{
	// Current result is saved in variable _x
	private _count = {alive _x} count units _x;
	private _marker = ([ROUT_ONE, ROUT_TWO, ROUT_THREE] call BIS_fnc_selectRandom) select 0;
	// private _location = markerPos _marker;
	private _location = position player;
	private _results =  [_x, (RED_UNIT_SIZE - _count), RED_UNITS_ARRAY, EAST_SPAWN] call  jMD_fnc_spawnGroups;
	private _waypoints = [_x, 200, _location, true, true] call jMD_fnc_deleteAndSetWaypoints;
} forEach ENEMY_GROUPS;

{
	// Current result is saved in variable _x
	scopeName "unitSpawn";
	private _groupSize = BLU_UNIT_SIZE; // desired size of each group
	private _count = {alive _x}count units _x;
	private _group = _x;
	// private _routArray = [ROUT_ONE, ROUT_TWO, ROUT_THREE] call BIS_fnc_selectRandom;
	private _results =  [_group, (_groupSize - _count), BLU_UNITS_ARRAY, WEST_SPAWN] call  jMD_fnc_spawnGroups;
	private _timer = 0;

	while { (({alive _x}count units _group) < _groupSize) && (_group != group player) } do {
		_timer = _timer + 1;
		private _count = {alive _x}count units _group;
		private _results =  [_group, (_groupSize - _count), BLU_UNITS_ARRAY, WEST_SPAWN] call  jMD_fnc_spawnGroups;
		if (_timer > 255) then { breakTo "unitSpawn"};
	};
	// if (count waypoints _x < 2) then {
	// 	// {
	// 	// 	private _loc = markerPos _x;
	// 	// 	private _waypoints = [_group, 50, _loc, false, false] call jMD_fnc_deleteAndSetWaypoints;
	// 	// }forEach _routArray;
	// 	private _wp = ARRAY_OF_ROUTES select 0;
	// 	private _waypoints = [_group, 100, markerPos _wp, false, false] call jMD_fnc_deleteAndSetWaypoints;
	// };
	if (doOnce < count FRIENDLY_GROUPS) then {
		_x setBehaviour "SAFE";
		FRIENDLY_GROUPS deleteAt(FRIENDLY_GROUPS find group player);
		doOnce = doOnce +1;
	};
} forEach FRIENDLY_GROUPS;

_vehicleType = RED_VEHICLE_ARRAY call BIS_fnc_selectRandom;
_veh = [ EAST_VEHICLE_SPAWN, 330, _vehicleType, east] call BIS_fnc_spawnVehicle;
hint format['Created vehicle %1', _veh select 0];
_vehGroup = _veh select 2;
_vehGroup setBehaviour "SAFE";
// [_vehGroup, 200, position player, true, false] call jMD_fnc_deleteAndSetWaypoints;
private _vWp = _vehGroup addWaypoint[position player, 50];
_vWp waypointAttachVehicle vehicle player;

{ if (_x distance player > 500) then { deleteVehicle _x}} forEach allDeadMen;

// check to see if all support assets are still alive

[] call jMD_fnc_choppaCheck;

// if asset is damaged and away from base...
	// if crew is alive, repair asset and order to return to base waypoint
	// if crew is dead, spawn new crew and order them to asset and to bring it back to base. 

diag_log 'Spawn loop end';
sleep 1200; //1200 = 20 min
saveGame;
ONE_LOOP = false;
[] spawn jMD_fnc_spawnLoop;