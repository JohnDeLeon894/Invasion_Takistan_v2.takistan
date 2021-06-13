// spawn reinforcements and load into chopper

private _transport = _this select 0;
private _group = group player;
private _troopLimit = BLU_UNIT_SIZE;
private _reinforcementCount = _troopLimit - ({alive _x} count units group player);
private _position = getMarkerPos 'westSpawn';

// hint 'started';

for [{ private _i =_reinforcementCount}, {_i > 0}, {_i = _i - 1}] do {
	private _soldier = bluforUnits call BIS_fnc_selectRandom;
	_unit = _group createUnit [_soldier, _position, [],0, "NONE"];
	_unit moveInAny _transport;
};

waitUntil {{_x in _transport} count units group player == _reinforcementCount};

reinforceReady = true;