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
	private _location = position player;
	private _results =  [_x, (RED_UNIT_SIZE - _count), RED_UNITS_ARRAY, EAST_SPAWN] call  jMD_fnc_spawnGroups;
	// private _waypoints = [_x, 200, _location, true, true] call jMD_fnc_deleteAndSetWaypoints;
		/*
	0: Group performing action, either unit <OBJECT> or group <GROUP>
	1: Range of tracking, default is 500 meters <NUMBER>
	2: Delay of cycle, default 15 seconds <NUMBER>
	3: Area the AI Camps in, default [] <ARRAY>
	4: Center Position, if no position or Empty Array is given it uses the Group as Center and updates the position every Cycle, default [] <ARRAY>
	5: Only Players, default true <BOOL>
	*/
	[_x, 10000, 60] spawn lambs_wp_fnc_taskHunt;
} forEach ENEMY_GROUPS;

{
	// Current result is saved in variable _x
	scopeName 'unitSpawn';
	private _groupSize = BLU_UNIT_SIZE; // desired size of each group
	private _count = {alive _x}count units _x;
	private _group = _x;
	private _results =  [_group, (_groupSize - _count), BLU_UNITS_ARRAY, WEST_SPAWN] call  jMD_fnc_spawnGroups;
	private _timer = 0;

	while { (({alive _x}count units _group) < _groupSize) && (_group != group player) } do {
		_timer = _timer + 1;
		private _count = {alive _x}count units _group;
		private _results =  [_group, (_groupSize - _count), BLU_UNITS_ARRAY, WEST_SPAWN] call  jMD_fnc_spawnGroups;
		if (_timer > 255) then { breakTo 'unitSpawn'};
	};
	if (doOnce < count FRIENDLY_GROUPS) then {
		_x setBehaviour 'SAFE';
		FRIENDLY_GROUPS deleteAt(FRIENDLY_GROUPS find group player);
		doOnce = doOnce +1;
	};
	// lambs_danger_OnInformationShared	_unit <Object>, _groupOfUnit <Group>, _target <Object>, _groups <Array<Groups>>
	[_x, 'lambs_danger_OnInformationShared', {
    params ['_unit', '_group', '_target', '_groups'];
    private ['_targetPos', '_targetGrid', '_message'];
		hint 'eventhandler fired!';
		_targetPos = position _target;
		_targetGrid = mapGridPosition _targetPos;
		_message = format ['I see the enemy at %1', _targetGrid];
		_units sideChat _message;
	}] call BIS_fnc_addScriptedEventHandler;
} forEach FRIENDLY_GROUPS;

_vehicleType = RED_VEHICLE_ARRAY call BIS_fnc_selectRandom;
_veh = [ EAST_VEHICLE_SPAWN, 330, _vehicleType, east] call BIS_fnc_spawnVehicle;
hint format['Created vehicle %1', _veh select 0];
_vehGroup = _veh select 2;
_vehGroup setBehaviour 'SAFE';
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
// saveGame;
ONE_LOOP = false;
[] spawn jMD_fnc_spawnLoop;