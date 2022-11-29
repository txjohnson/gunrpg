extends Reference
class_name Architecture

var architect :Architect
var style     :ArchitecturalStyle



func _init (s :ArchitecturalStyle, a :Architect):
	architect = a
	style = s
	
func depth():
	return architect.depth
	
func bounds():
	return architect.stage.bounds
	
func width():
	return architect.stage.width
	
func height():
	return architect.stage.height;
	
func carve_density ():
	var possible = width() - 2 * height() - 2
	return architect.carved_tiles / possible

