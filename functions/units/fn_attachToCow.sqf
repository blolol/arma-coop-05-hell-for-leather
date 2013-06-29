private ["_cow", "_gunner"];
_gunner = _this select 0;
_cow = _this select 1;

_gunner attachTo [_cow, [0.3, 1.0, 2.0]];
