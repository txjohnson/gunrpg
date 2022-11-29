extends Node

var tile_map: TileMap

export var void_tile :int = 0

func _ready () -> void:
	tile_map = get_parent() as TileMap
	

func generate ():
	pass

