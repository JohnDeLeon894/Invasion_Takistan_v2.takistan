// called from radio. 
private _pos = _this select 0;
private _action = _this select 1;
// check for available transport
hint 'transport called';
{
	// Current result is saved in variable _x
	private _tooFarFromLZ = _x distance TRANSPORT_ZONE > 100;
	if(!(alive _x)) then {
		hint 'transport not alive';
		TRANSPORTS deleteAt (TRANSPORTS find _x);
		continue;
	};
	if (_tooFarFromLZ) then { hint 'too far from lz'; continue; };
	// if(!(_x getVariable ['onMission', false]) && !(_tooFarFromLZ)) exitWith{
	if(!(_tooFarFromLZ)) exitWith{
		hint format ['%1 on the move', _x];
		[_x, _action, _pos]execVM "functions\transport\transportAction.sqf";
	};
} forEach TRANSPORTS;