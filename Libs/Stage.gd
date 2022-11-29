extends Reference
class_name Stage

var width  :int
var height :int
var map    :TileMap

enum { UNFORMED = 0, WALL = 1, FLOOR = 2, DOOR = 3,  }

func _init (w:int, h:int):
	width = w
	height = h
	map    = TileMap.new()
	

func bounds() -> Rect2:
	return Rect2 (0, 0, width, height)
