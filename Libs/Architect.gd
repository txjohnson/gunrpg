extends Reference
class_name Architect


var stage        :Stage
var style        :ArchitecturalStyle
var carved_tiles :int = 0

func _init (s :Stage):
	stage = s
	

func build_stage():
	close_off_bounds ()


func close_off_bounds () -> void:
	for y in range(0, stage.height + 1):
		stage.map.set_cell (0, y, Stage.UNFORMED)
		stage.map.set_cell (stage.width + 1, y, Stage.UNFORMED)

	for x in range(0, stage.width + 1):
		stage.map.set_cell (x, 0, stage.UNFORMED)
		stage.map.set_cell (x, stage.height + 1, stage.UNFORMED)
		

func carve (x :int, y :int, t :int) -> void:
	stage .map .set_cell (x, y, t)
	++carved_tiles
	
