['intro',false] call BIS_fnc_blackOut;
COMMON_DONE = false ;
[] execVM 'common.sqf';
waitUntil {COMMON_DONE};
[] spawn jMD_fnc_spawnLoop;
// private _groupsNamed = false;
_groupsNamed = [] execVM 'nameAllGroups.sqf';
['intro', true] call BIS_fnc_blackIn;