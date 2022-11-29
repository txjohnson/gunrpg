extends Reference
class_name Util




static func one_in (r :RandomNumberGenerator, n:int) -> bool:
	if r.randi_range (1, n) == 1: return true
	return false
	
static func taper (r :RandomNumberGenerator, start :int, chance :int) -> int:
	while one_in (r, chance):
		++start
	return start
