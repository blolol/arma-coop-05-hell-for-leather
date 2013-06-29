private ["_marker", "_position", "_markerPos", "_markerPosX", "_markerPosY", "_markerSize",
	"_markerSizeX", "_markerSizeY", "_markerRadiusX", "_markerRadiusY", "_markerMinX",
	"_markerMinY", "_markerMaxX", "_markerMaxY", "_positionX", "_positionY"];

_marker = _this select 0;
_position = _this select 1;

_markerPos = getMarkerPos _marker;
_markerPosX = _markerPos select 0;
_markerPosY = _markerPos select 1;

_markerSize = getMarkerSize _marker;
_markerSizeX = _markerSize select 0;
_markerSizeY = _markerSize select 1;
_markerRadiusX = _markerSizeX / 2;
_markerRadiusY = _markerSizeY / 2;

_markerMinX = _markerPosX - _markerRadiusX;
_markerMinY = _markerPosY - _markerRadiusY;
_markerMaxX = _markerPosX + _markerRadiusX;
_markerMaxY = _markerPosY + _markerRadiusY;

_positionX = _position select 0;
_positionY = _position select 1;

(_positionX >= _markerMinX) &&
(_positionX <= _markerMaxX) &&
(_positionY >= _markerMinY) &&
(_positionY <= _markerMaxY);
