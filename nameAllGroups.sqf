{
	if (side _x == WEST) then {
		[_x]execVM 'setGroupCallSign.sqf';
	};
} forEach allGroups;

true;