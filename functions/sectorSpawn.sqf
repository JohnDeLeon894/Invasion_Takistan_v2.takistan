// creates enemy groups and sets them to patrol or garison near their spawn marker
// [trigger, group size] call jMD_fnc_sectorspawn

private _trigger	 = _this select 0;
private _groupsize	 = _this select 1;
private _nearbyLocations = _this select 2;
private _usePosition = _this select 3;
private _arearadious = _this select 4;
private _locationcount = count _nearbyLocations;
private _resultsArray = [];
hint format ['trigger: %1', _trigger];

// private _markers = EAST_POSITIONS select {(getmarkerPos _x) inArea _trigger};
// hint format _markers;
private _spawnedCount = 0;
private _tries = 0;

while {_spawnedCount < 6} do {
     private ['_position', '_groupname', '_waypointScript', '_wp'];

    private _selectedLocation = _nearbyLocations call BIS_fnc_selectRandom;
    _resultsArray pushBack _selectedLocation;
    
    groupcount = groupcount + 1;
    _spawnedCount = _spawnedCount + 1;
    
    _groupname = format ['enemygroup_%1', groupcount];
    _groupname = creategroup [east, false];
    _waypointScript = [
        "\z\lambs\addons\wp\scripts\fnc_wpPatrol.sqf",
        "\z\lambs\addons\wp\scripts\fnc_wpGarrison.sqf"
    ] call BIS_fnc_selectRandom;

    if ( _usePosition ) then {
        _position = position _selectedLocation; 
    } else {
        _position = locationposition _selectedLocation
    };

    hint format['groupName = %1 \n groupSize = %2 \n unitsArray = %3 \n position = %4', _groupname, _groupsize, RED_units_ARRAY, _position];
    [_groupname, _groupsize, RED_UNITS_ARRAY, _position] call jMD_fnc_spawngroups;
    
    _wp = _groupname addWaypoint [_position, 200];
    // [_groupname, (count waypoints _groupname) - 1 ] setwaypointScript _waypointScript;
    _wp setWaypointType 'DISMISS';
    _wp setWaypointBehaviour 'SAFE';
};

_resultsArray 