private _choppaCount = count TRANSPORTS;

 private _choppaCheck = {
		private _choppa = this select 0;
		HINT format['Choppa %1 cant move', _choppa];
		private _choppaName =  vehicleVarName _choppa;
		private _hawkNumber = parseNumber (_choppaName splitString 'k' select 1) + 3;
		diag_log _hawkNumber;
		private _newName = format['Hawk%1', _hawkNumber];
		diag_log _choppaName;
		_choppa setDamage 1; 
		TRANSPORTS deleteAt (TRANSPORTS find _x);
		private _hawk = 'RHS_UH60M2_d' createVehicle markerPos 'CHOPPA_SPAWN';
		private _hawkGroup = createVehicleCrew _hawk;
		diag_log _hawk;
		_hawkGroup setVariable ['TCL_Disabled', true];
		missionNamespace setVariable [_newName, _hawk];
		_hawk setVehicleVarName _newName;
		
		diag_log ['is the Variable nil?', isNil _newName];
		diag_log 'setting newName on created vehicle';
		_newName = _hawk;
		diag_log ['is the Variable nil?', _newName];
		diag_log ['variable name', vehicleVarName _hawk];
		TRANSPORTS pushBack _hawk; 
		[_hawk]execVM 'functions\transport\transport_infil_action.sqf';
};

{ 
 	private _choppa = _x; 
 	private _canMove = canMove _choppa; 
	private _choppaName =  vehicleVarName _choppa;
 	private _status =  ['The Choppa status',format['the Choppa"s status is %1', _canMove]]; 
 	player createDiarySubject['choppaStatus', 'Chopper Status']; 
 	player createDiaryRecord ['choppaStatus', _status]; 
	diag_log format['the Choppa"s status is %1', _canMove];
 
 if ( !(_canMove) ) then { 
	 [_choppa] call _choppaCheck;
 }; 
}  forEach TRANSPORTS;

while {_choppaCount < 3} do {
	private _randomNumber = random 100;
	format ['foHawk%1', _randomNumber] call _choppaCheck;
};

