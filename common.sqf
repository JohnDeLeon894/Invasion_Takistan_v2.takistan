// create groups 
// enemy groups
attackGroup_1 = createGroup [east, false];
attackGroup_2 = createGroup [east, false];
attackGroup_3 = createGroup [east, false];
attackGroup_4 = createGroup [east, false];
attackGroup_5 = createGroup [east, false];
attackGroup_6 = createGroup [east, false];
attackGroup_7 = createGroup [east, false];
attackGroup_8 = createGroup [east, false];

// friendly groups 
ally_1 = group player;
ally_2 = createGroup [west, false];
ally_3 = createGroup [west, false];
ally_4 = createGroup [west, false];
ally_5 = createGroup [west, false];
ally_6 = createGroup [west, false];
ally_7 = createGroup [west, false];

ENEMY_GROUPS = [
	attackGroup_1,
	attackGroup_2,
	attackGroup_3,
	attackGroup_4,
	attackGroup_5,
	attackGroup_6
];

FRIENDLY_GROUPS = [
	ally_1,
	ally_2,
	ally_3,
	ally_4,
	ally_5
];
ARTY = [
	m1,
	m2,
	m3,
	m4
];

// variable for counting stuff
GROUP_COUNT = 0;
continueLoop = true;
doOnce = 0;
ONE_LOOP = false;
BLU_UNIT_SIZE = 8;
RED_UNIT_SIZE = 8;

// find the marker 
// spawn points 

WEST_SPAWN = markerPos ["westSpawn", true];
EAST_SPAWN = markerPos ["eastSpawn", true];
AMMO_ZONE = markerPos [ 'ammoTruckZone', true];
TRANSPORT_ZONE = markerPos ['rtz', true];
EAST_VEHICLE_SPAWN = markerPos ['eastVehicleSpawn', true];
CHOPPA_SPAWN = markerPos ['CHOPPA_SPAWN', true];

// all trigger
ALL_TRIGGERS = [];
{
	private _trig = format ['%1',_x];
	if ('sector' in _trig) then {
		player createDiarySubject ['TriggersFound', 'Triggers Found'];
		private _title = format ['Found %1', _trig];
		private _entry = format ['Found trigger %1. Distance from player %2', _trig, player distance _x];
		player createDiaryRecord ['TriggersFound', [_title, _entry]];
		ALL_TRIGGERS pushBack _x;
	};
} forEach allMissionObjects 'EmptyDetector';

TRANSPORTS = [
	Hawk_1,
	Hawk_2,
	Hawk_3
];

CAS = [
	Buzzard_01
];

// blufor routs 

ROUT_ONE = [];
ROUT_TWO = [];
ROUT_THREE = [];

LOCATION_TYPES = [
    'Airport',
    'Area',
    'BorderCrossing',
    'CityCenter',
    'CivilDefense',
    'CulturalProperty',
    'DangerousForces',
    'Flag',
		'FlatArea',
    'FlatAreaCity',
    'FlatAreaCitySmall',
    'HistoricalSite',
    'NameCity',
    'NameCityCapital',
    'NameMarine',
    'NameVillage',
    'SafetyZone',
    'Strategic',
    'StrongpointArea',
    'ViewPoint'
];

// units arrays 
// enemy units 
Isis_Vehicles = ['LOP_ISTS_OPF_Offroad_M2', 'LOP_ISTS_OPF_M113_W', 'LOP_ISTS_OPF_BTR60', 'LOP_ISTS_OPF_Landrover_M2', 'LOP_ISTS_OPF_M1025_W_M2', 'O_IS_Technical_Armed_01', 'O_IS_Captured_Humvee_01'];
// enemy soldiers array
Isis_Unit_Configs = "getText (_x >> 'faction') == 'LOP_ISTS_OPF' && getText (_x >> 'simulation') == 'soldier'" configClasses (configFile >> "CfgVehicles");
Isis_units = Isis_Unit_Configs apply {configName _x};

BocoHaran_Unit_Configs = "getText (_x >> 'faction') == 'LOP_BH' && getText (_x >> 'simulation') == 'soldier'" configClasses (configFile >> "CfgVehicles");
BocoHaran_units = BocoHaran_Unit_Configs apply {configName _x};

IslamicState_Unit_Configs = "getText (_x >> 'faction') == 'IS' && getText (_x >> 'simulation') == 'soldier'" configClasses (configFile >> "CfgVehicles");
IslamicState_units = IslamicState_Unit_Configs apply {configName _x};

// new vietnam troups
NVA_Unit_Configs = "getText (_x >> 'faction') == 'O_PAVN' && getText (_x >> 'simulation') == 'soldier'" configClasses (configFile >> "CfgVehicles");
NVAUnits = NVA_Unit_Configs apply {configName _x};
NVA_Vehicle_Configs = "getText (_x >> 'faction') == 'O_VC' && getText (_x >> 'simulation') == 'carX'" configClasses (configFile >> "CfgVehicles");
NVAVehicles = NVA_Vehicle_Configs apply {configName _x};

// friendly soldiers array 
bluforUnitsConfig= "getText (_x >> 'faction') == 'rhs_faction_usmc_wd' && getText (_x >> 'simulation') == 'soldier' && getText (_x >> 'role') != 'Crewman'" configClasses (configFile >> "CfgVehicles");
bluforUnits = bluforUnitsConfig apply {configName _x};

// new macv units
MACVUnitsConfig= "getText (_x >> 'faction') == 'B_MACV' && getText (_x >> 'simulation') == 'soldier' && getText (_x >> 'role') != 'Crewman'" configClasses (configFile >> "CfgVehicles");
MACVUnits = MACVUnitsConfig apply {configName _x};

// desert camo friendly soldiers
bluforDesertUnitsConfig= "
	getText (_x >> 'faction') == 'rhs_faction_usmc_d' && 
	getText (_x >> 'simulation') == 'soldier' && 
	getText (_x >> 'role') != 'Crewman'"
	 configClasses (configFile >> "CfgVehicles");
bluforDesertUnits = bluforDesertUnitsConfig apply {configName _x};

// desert camo nato soldiers
natoDesertUnitsConfig= "getText (_x >> 'faction') == 'BLU_NATO_lxWS' && getText (_x >> 'simulation') == 'soldier' && getText (_x >> 'role') != 'Crewman'" configClasses (configFile >> "CfgVehicles");
natoDesertUnits = natoDesertUnitsConfig apply {configName _x};

natoUnitsConfig= "getText (_x >> 'faction') == 'BLU_F' && getText (_x >> 'simulation') == 'soldier' && getText (_x >> 'role') != 'Crewman'" configClasses (configFile >> "CfgVehicles");
natoUnits = natoUnitsConfig apply {configName _x};




// global variable for units array
BLU_UNITS_ARRAY = bluforDesertUnits;

RED_UNITS_ARRAY = Isis_units + BocoHaran_units + IslamicState_units;

RED_VEHICLE_ARRAY = Isis_Vehicles;

COMMON_DONE = true;