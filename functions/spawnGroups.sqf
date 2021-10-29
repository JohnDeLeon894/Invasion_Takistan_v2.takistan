// spawns units when called
// [_group, _count, _unitsArray, _position] call spawnGroups;

private _group 			= _this select 0;
private _count 			= _this select 1;
private _unitsArray		= _this select 2;
private _position 		= _this select 3;

// private _unitsCreated = [];
if(_count < 1 ) exitWith {hint "exiting spawn loop"};
// spawns unit and adds to group
for [{private _i=0}, {_i<_count}, {_i=_i+1}] do {
	private _soldierRole =  _unitsArray call BIS_fnc_selectRandom; 
	// _soldierRole createUnit [_position, _group];
	_group createUnit [_soldierRole, [_position select 0, _position select 1], [], 50, "NONE"];
	// _unitsCreated pushBack _soldierRole;
	// hint __unitsCreated
};

// return value
_group