private _casPos = position player;
private _CAS = CAS call BIS_fnc_selectRandom;
private _gridPos = mapGridPosition _casPos;
private _CASMessage = format['%1 requesting CAS position %2, over!', player, _gridPos];
player commandChat _CASMessage;

if (!alive _CAS) then {
	CAS deleteAt _CAS;
	 if (count CAS < 1) exitWith {
		 player commandChat 'There is currently no CAS available, no ETA on when a bird will be in the air.';
		 []execVM 'functions/CAS/callCAS.sqf';
	 } 
};

group _CAS setBehaviour 'AWARE';
private _CASAffirmMessage = format['%1 affirm, this is %2 responding to CAS mission for position %3', player, _CAS, _gridPos];
 player commandChat _CASAffirmMessage;
_CAS move _casPos;

sleep 300;

private _CASRTB = format['%1 this is %2, we are RTB to refule and rearm. Goodluck down there.', player, _CAS];
player commandChat _CASRTB;
group _CAS setBehaviour 'CARELESS';

_CAS move getMarkerPos 'rtz';

waitUntil {unitReady _CAS};

if (unitReady _CAS) then
 { 
	hint "landing";
	_CAS land "land";
	sleep 30;
	hint format['%1 ready for nextmission', _CAS];
	_CAS setFuel 1;
	{
		_CAS setAmmo[_x, 10000];
	} forEach weapons _CAS
};