
private _markerCount = 0;
private _fireMissionFailed = false;
player createDiarySubject['Arty Record', 'Artilory Record'];


private _nameFireMission = {
	private _verb = VERBS call BIS_fnc_selectRandom;
	private _noun = NOUNS call BIS_fnc_selectRandom;
	private _adjective = ADJECTIVES call BIS_fnc_selectRandom;
	private _newName = format ['fire mission %1 %2 %3', _verb, _adjective, _noun];
	_newName
};
private _replaceMarker = {
	private _mark = _this select 0;
	private _missionName = _this select 1;

	m1 globalChat "replacing marker";
	// private _fireMissionName = [] call _nameFireMission;
	private _artyMarker = createMarker [_fireMissionName, _pos ];
	_artyMarker setMarkerType "mil_warning_noShadow";
	_artyMarker setMarkerText _missionName;
	_artyMarker setMarkerColor 'ColorRed';
	format['original name %1', _missionName];
	deleteMarker _mark;
};

{
	private _fireMissionName = [] call _nameFireMission;
	private _step = 0;
	if ((_x find "_USER_DEFINED") >= 0 && markerText _x == 'arty') then {

		private _scopedMarker = _x;
		player commandChat format['original name %1', _fireMissionName];
		private _pos = markerPos _scopedMarker;
		private _gridPos = mapGridPosition _pos;
		private _artyMessage = format ['This is %1 requesting arty mission on grid %2, how copy over.', groupId group player, _gridPos];
		private _firMissionRecord = player createDiaryRecord ['Arty Record',[_fireMissionName, _artyMessage]];
		player commandChat _artyMessage;
		private _timesFailed = 0;

		sleep 5;

		{	
			_x setAmmo [currentWeapon _x, 12];
			if(unitReady _x) exitWith {
				_step = _step + 1; 
				hint format['stopped at step %1',_step];
				[_scopedMarker, _fireMissionName] call _replaceMarker;
				private _eta = _x getArtilleryETA[_pos, "rhs_12Rnd_m821_HE"];
				private _artyResponse = format ['%1, firing on grid %2. Rounds ETA in %3. Out.', _x, _gridPos, _eta];
				_x commandChat _artyResponse;
				_firMissionRecord = player createDiaryRecord ['Arty Record',[_fireMissionName, _artyResponse]];
				_x commandArtilleryFire [_pos, "rhs_12Rnd_m821_HE", 12];
			};
			_step = _step + 1; 
			_timesFailed = _timesFailed + 1;
			hint format['stopped at step %1',_step];
			private _artyNotReady = format ['%1 is not ready', _x];
			_x commandChat _artyNotReady;
			 player createDiaryRecord ['Arty Record',[_fireMissionName, _artyNotReady]];
			if ( _timesFailed > 4) exitWith {
				_fireMissionFailed = true;
			}
		} forEach ARTY;
	};

	if (_fireMissionFailed) exitWith {

		private _noGuns = 'No guns currently available, call new mission ';
		player createDiaryRecord ['Arty Record',[_fireMissionName, _noGuns]];
		m1 sideChat 'No guns currently available, call new mission ';
	};
	
} forEach allMapMarkers;

