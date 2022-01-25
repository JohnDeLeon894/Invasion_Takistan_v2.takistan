hint 'activated!';
private ['_player', '_closestTrigger', '_currentTrigger'];
_player = player;
_closestTrigger = ALL_TRIGGERS select 0;

{
	private _distanceA = player distance _x;
	private _distanceB = player distance _closestTrigger;
	if (_distanceA < _distanceB) then {
		_closestTrigger = _x;
	};
} forEach ALL_TRIGGERS;
// _closestTrigger = ALL_TRIGGERS call BIS_fnc_selectRandom;

private _copyStatements = triggerStatements _closestTrigger;
private _copyActivation = _copyStatements select 1;
private _copyDeactivation = _copyStatements select 2;

_closestTrigger setTriggerStatements ['true', _copyActivation, _copyDeactivation];

ALL_TRIGGERS deleteAt (ALL_TRIGGERS find _closestTrigger);