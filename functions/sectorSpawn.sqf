// creates enemy groups and sets them to patrol or garison near their spawn marker
// [trigger, group size] call jMD_fnc_sectorspawn

private _trigger	 = _this select 0;
private _groupsize	 = _this select 1;
private _nearbyLocations = _this select 2;
private _usePosition = _this select 3;
private _arearadious = _this select 4;
private _parentTaskId = _this select 5;
private _state = 'AUTOASSIGNED';
private _owner = WEST;
private _priority = -1;
private _locationcount = count _nearbyLocations;
private _resultsArray = [];
hint format ['trigger: %1', _trigger];

// private _markers = east_positionS select {(getmarkerPos _x) inArea _trigger};
// hint format _markers;
private _spawnedcount = 0;
private _tries = 0;

while {_spawnedcount < 6} do {
    private ['_position', '_groupname', '_waypointScript', '_wp', '_selectedLocation', '_eastGroup'];
    
    _selectedLocation = _nearbyLocations call BIS_fnc_selectRandom;
    _nearbyLocations deleteAt (_nearbyLocations find _selectedLocation);
    _resultsArray pushBack _selectedLocation;
    
    groupcount = groupcount + 1;
    _spawnedcount = _spawnedcount + 1;
    
    _groupname = format ['enemygroup_%1', groupcount];
    _eastGroup = creategroup [east, false];
    _eastGroup setGroupId [_groupname];
    
    if (_usePosition) then {
        _position = position _selectedLocation;
    } else {
        _position = locationposition _selectedLocation
    };

    _eastGroup = [_eastGroup, (_groupsize + random 4), RED_units_ARRAY, _position] call jMD_fnc_spawngroups;
    
    _wp = _eastGroup addWaypoint [_position, 200];
    _wp setwaypointType 'DISMISS';
    _wp setwaypointBehaviour 'SAFE';
        /*
        0: Group performing action, either unit <OBJECT> or group <GROUP>
        1: Position to occupy, default group location <ARRAY or OBJECT>
        2: Range of tracking, default is 50 meters <NUMBER>
        3: Area the AI Camps in, default [] <ARRAY>
        4: Teleport Units to Position <BOOL>
        5: Sort Based on Height <BOOL>
        6: Exit Conditions that breaks a Unit free (-2 Random, -1 All, 0 None, 1 Hit, 2 Fired, 3 FiredNear, 4 Suppressed), default -2 <NUMBER>
        7: Sub-group patrols the area <BOOL>
    */
    [_eastGroup, _position, 200, [], false,true,-1, true] call lambs_wp_fnc_taskGarrison;
    // creating diary record and task
    private ['_childTasIdk', '_description', '_completedChildren', '_activation', '_statement'];
    _childTasIdk = format['Patrol_%1', _selectedLocation];
    _description = [format['Enemy soldiers were spotted near %1. Patrol the area and engage any units you come across.', _selectedLocation], format['Patrol %1', _selectedLocation], _selectedLocation];
    _activation = format['["%1", "SUCCEEDED"] call BIS_fnc_tasksetState;', _childTasIdk];
    
    [_owner, [_childTasIdk, _parentTaskId], _description, _position, _state, _priority, _shownotification, _type, _visiblein3D] call BIS_fnc_taskCreate;
    [_eastGroup, _childTasIdk] execVM 'functions\groupTracker.sqf';

    private _diaryTitle = format['Trigger %1 created:', _trigger];
    player createDiaryRecord ['taskRecord', [_diaryTitle, format['this is the marker found: %1', _selectedLocation]]];
    player createDiaryRecord ['taskRecord',[_diaryTitle,format['This is the current group count: %1', ({alive _x} count units _eastGroup)]]];
    player createDiaryRecord ['taskRecord',[_diaryTitle,format['This is the current group name: %1', _groupname]]];
    player createDiaryRecord ['taskRecord',[_diaryTitle,format['This is the current group id: %1', groupId _eastGroup]]];
};

_resultsArray