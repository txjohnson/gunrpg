extends Node2D

enum DTT { UNUSED = -1, WALL = 1, FLOOR = 2,DOOR = 3 }

class DungeonMazeConfig:
	var num_room_tries :int = 50
	var extra_connector_changer :int = 50
	var room_extra_size :int = 0
	var windind_pcnt :float = 50
	var width
	var height	
	
	

class DungeonMazeGen:
	var cfg :DungeonMazeConfig
	var map :TileMap
	var rooms = []
	var current_region :int = -1
	var rnd = RandomNumberGenerator.new()
	
	func _init (config :DungeonMazeConfig):
		cfg = config
		map = TileMap.new()
		pass

	func generate () -> bool:
		if (cfg.width < 5):
			print("DungoneMazeGen: DungeonMazeConfig.width must be at least 5. received ", cfg.width)
			return false
		
		if (cfg.width % 2 == 0):
			print("DungoneMazeGen: DungeonMazeConfig.width must be an odd number. received ", cfg.width)
			return false

		if (cfg.height < 5):
			print("DungoneMazeGen: DungeonMazeConfig.height must be at least 5. received ", cfg.height)
			return false

		if (cfg.height % 2 == 0):
			print("DungoneMazeGen: DungeonMazeConfig.height must be an odd number. received ", cfg.height)
			return false

		map .clear ()
		fill (DTT.WALL)
		return true
		pass


	func fill (t :int):
		for x in range (0, cfg.width):
			for y in range (0, cfg.height):
				map.set_cell(x, y, t)

	func one_in (n :int):
		return rnd.randi_range (1, n) == 1	

	func make_rooms ():
		for i in range (0, cfg.num_room_tries):
			var size = rnd.randi_range(1, 3 + cfg.room_extra_size) * 2 + 1
			var rectangularity = rnd.randi_range(0, 1 + floor(size / 2)) * 2
			var width = size
			var height = size
			if one_in(2):
				width += rectangularity
			else:
				height += rectangularity
				
			var x = rnd.randi_range(0, floor ((cfg.width - width) / 2)) * 2 + 1
			var y = rnd.randi_range(0, floor ((cfg.height - height) / 2)) * 2 + 1
			
			if x + width > cfg.width:
				x = max (1, cfg.width - width - 1)
			
			if y + height > cfg.height:
				y = max (1, cfg.height - height - 1)
				
			var room = Rect2 (x, y, width, height)
			
			var overlaps:bool = false
			
			for r in rooms:
				if r.intersects (room):
					overlaps = true
			
			if overlaps:
				continue
			
			rooms .push_back(room)
			++current_region
			carve_area (DTT.FLOOR, x, y, width, height)
		pass
		
	func fill_with_mazes ():
		for y in range(1, cfg.height):
			for x in range (1, cfg.width):
				if map.get_cell (x, y) == DTT.WALL:
					grow_maze (x, y)

	func grow_maze (x:int, y:int):
		var cells = []
		var last_dir
		
		if has_a_floor_as_neighbor (x, y): return
		
		++current_region
		map .set_cells (DTT.FLOOR, x, y)
		
		pass

	func has_a_floor_as_neighbor (x: int, y :int) -> bool:
		if map.get_cell (x - 1, y - 1) == DTT.FLOOR: return true
		if map.get_cell (x    , y - 1) == DTT.FLOOR: return true
		if map.get_cell (x + 1, y - 1) == DTT.FLOOR: return true
		if map.get_cell (x - 1, y    ) == DTT.FLOOR: return true
		if map.get_cell (x + 1, y    ) == DTT.FLOOR: return true
		if map.get_cell (x - 1, y + 1) == DTT.FLOOR: return true
		if map.get_cell (x    , y + 1) == DTT.FLOOR: return true
		if map.get_cell (x + 1, y + 1) == DTT.FLOOR: return true
		return false

	func carve_area (t:int, x:int, y:int, width:int, height:int):
		for xi in range(x, x + width):
			for yi in range(y, y + height):
				map.set_cell(xi, yi, t)
				
	func carve (t:int, x:int, y:int):
		map.set_cell(x, y, t)



func _ready():
	pass # Replace with function body.

