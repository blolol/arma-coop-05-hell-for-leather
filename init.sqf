waitUntil { !(isNil "bis_fnc_init"); };

if (isServer) then {
	call compile preprocessfile "vendor\shk_pos\shk_pos_init.sqf";

	setWind [20, 0, true];

	_cowOfficer = cowGroup createUnit ["Cow04", (getMarkerPos "cowSpawn0"), [], 0, "NONE"];
	_cowOfficer allowDamage false;
	americanFlag attachTo [_cowOfficer, [0, 1, 0.5]];

	deleteVehicle cowOfficer;
	cowOfficer = _cowOfficer;

	private ["_cowGroup"];
	gunners = [gunner1, gunner2, gunner3, gunner4];

	for "_i" from 0 to ((count gunners) - 1) do {
		private ["_cow", "_gunner", "_marker"];
		_gunner = gunners select _i;
		_marker = format ["cowSpawn%1", (_i + 1)];

		_gunner allowDamage false;
		(gunner _gunner) allowDamage false;

		_cow = cowGroup createUnit ["Cow04", (getMarkerPos _marker), [], 0, "NONE"];
		_cow allowDamage false;
		_cow disableAI "FSM";

		[_gunner, _cow] call BLOL_fnc_attachToCow;
	};

	[cowOfficer, gunners] spawn {
		private ["_gunners", "_killzones", "_unit"];
		_unit = _this select 0;
		_gunners = _this select 1;
		_killzones = ["killzone1", "killzone2", "killzone3", "killzone4", "killzone5"];

		while { true } do {
			private ["_cowPosition", "_killzone"];
			_cowPosition = position _unit;
			_killzone = ([_killzones, {
				[_x, _cowPosition] call BLOL_fnc_isInMarker;
			}] call BIS_fnc_conditionalSelect) call BIS_fnc_selectRandom;

			if (!(isNil "_killzone")) then {
				private ["_class", "_enemyGroup", "_spawnPosition"];
				_class = ["RU_Soldier", "RU_Soldier_AR", "RU_Soldier_MG",
					"RU_Soldier_AT", "RU_Soldier_GL"] call BIS_fnc_selectRandom;
				_spawnPosition = [_killzone] call SHK_pos;
				_enemyGroup = createGroup ([east] call CBA_fnc_createCenter);
				_enemyGroup setCombatMode "RED";
				_enemy = _enemyGroup createUnit [_class, _spawnPosition, [], 10, "NONE"];

				_target = (_gunners call BIS_fnc_selectRandom);
				_enemy doTarget _target;
				_enemy doFire _target;

				_enemy addEventHandler ["killed", {
					[_this select 0] spawn {
						sleep ([3, 5] call BIS_fnc_randomInt);
						private ["_group", "_unit"];
						_unit = _this select 0;
						_group = group _unit;
						deleteVehicle _unit;
						deleteGroup _group;
					};
				}];

				[_enemy] spawn {
					sleep 30;
					private ["_group", "_unit"];
					_unit = _this select 0;
					if (alive _unit) then {
						_group = group _unit;
						deleteVehicle _unit;
						deleteGroup _group;
					};
				};
			};

			sleep 1;
		};
	};
};
