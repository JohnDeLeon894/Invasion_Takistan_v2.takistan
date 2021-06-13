// [] execVM 'wordArrayDefinitions.sqf';
[] execVM 'common.sqf';
sleep 0.5;
[] spawn jMD_fnc_spawnLoop;
[] execVM 'nameAllGroups.sqf';