/*
onMapSingleClick '
onMapSingleClick "";
[this, _action, _pos]execVM "functions\transport\transportAction.sqf";';
*/

private _transport = _this select 0;
private _action = _this select 1; 
private _pos = _this select 2;
private _mapGrid = mapGridPosition _pos;

_transport setVariable ["onMission", true];

// hint format ['transport %1',_transport];
if (_action == 'reinforce') then {
	reinforceReady = false; 
	call compile format['[%1] execVM "functions\transport\transport_%2_action.sqf"', _transport, _action];
	_action = 'infil';
	waitUntil {reinforceReady};	
};

_transport sideChat format ['%1 moving to grid %2, action %3', _transport, _mapGrid, _action];
// hint format ['%1 moving to grid %2, action %3', _transport, _mapGrid, _action];
_transport move _pos;
USER_LZ setPos _pos;

waitUntil {unitReady _transport};

if (unitReady _transport) then 
 { 
	_transport land "GET IN"; // used only for helicopters
	_transport sideChat "We're at the destination, exit when ready.";
};

waitUntil{unitReady _transport};
if (_action != 'reinforce') then {
call compile format['[%2] execVM "functions\transport\transport_%1_action.sqf"', _action, _transport];
};