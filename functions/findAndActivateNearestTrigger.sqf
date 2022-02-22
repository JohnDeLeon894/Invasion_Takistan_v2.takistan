hint 'activated!';
private ['_player', '_closestTrigger', '_currentTrigger', '_nextClosest', '_selectedTrigger'];
_player = player;
_closestTrigger = ALL_TRIGGERS select 0;
_nextClosest = ALL_TRIGGERS select 0;
_lastClosest = ALL_TRIGGERS select 0;

{
	private _distanceA = player distance _x;
	private _distanceB = player distance _closestTrigger;
	private _distanceC = player distance _nextClosest;
	private _distanceD = player distance _lastClosest;
	if (_distanceA < _distanceB) then {
		_closestTrigger = _x;
	} else {
		if (_distanceA < _distanceC) then {
			_nextClosest = _x;
		} else {
			if (_distanceA < _distanceD) then {
				_lastClosest = _x;
			};
		};
	};
} forEach ALL_TRIGGERS;
// _closestTrigger = ALL_TRIGGERS call BIS_fnc_selectRandom;
private _triggerList = [_closestTrigger, _nextClosest, _lastClosest];
_selectedTrigger = _triggerList call BIS_fnc_selectRandom;
private _subject = player createDiarySubject ['triggerPicker', 'trigger picker'];
private _triggerListText = format['%1', _triggerList];
player createDiaryRecord ['triggerPicker', ['the trigger array', _triggerListText]];
player createDiaryRecord ['triggerPicker', ['the trigger chosen', format['%1',_selectedTrigger]]];

private _copyStatements = triggerStatements _closestTrigger;
private _copyActivation = _copyStatements select 1;
private _copyDeactivation = _copyStatements select 2;

_closestTrigger setTriggerStatements ['true', _copyActivation, _copyDeactivation];

ALL_TRIGGERS deleteAt (ALL_TRIGGERS find _closestTrigger);