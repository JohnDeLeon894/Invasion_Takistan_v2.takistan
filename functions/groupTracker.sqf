// creates a loop that waits until the given group is no longer alive
//create variable for group that is passed in
private _group = _this select 0;
private _childTaske = _this select 1;
private _diaryTitle = format['group tracking: %1', _group];
private _troops = units _group;

player createDiaryRecord ['taskRecord', [_diaryTitle, format['group %1 is is being tracked', _group]]];
// waitUntil given group no longer has any living members
waitUntil {({alive _x}count _troops) == 0};
// create a diary record stating this group has been killed
player createDiaryRecord ['taskRecord', [_diaryTitle, format['group %1 is dead', _group]]];
[_childTaske, "SUCCEEDED"] call BIS_fnc_tasksetState;
