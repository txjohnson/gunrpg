extends Node


enum DamageType { MELEE, MANA }

class Armor:
	var melee_hp  :int
	var melee_min :int
	var melee_mod :float
	var magic_hp   :int
	var magic_min  :int
	var magic_mod  :float
	
	func _init(mehp :int, memin :int, memod :float, mahp :int, mamin :int, mamod :float):
		melee_hp  = mehp
		melee_min = memin
		melee_mod = memod
		magic_hp   = mahp
		magic_min  = mamin
		magic_mod  = mamod


	func take_damage (melee :int, magic :int) -> float:
		var memod = melee_mod
		var memin = melee_min
		var mamin = magic_min
		var mamod = magic_mod
		
		if melee_hp == 0:
			memod = 1.0
			memin = 0
		
		if magic_hp == 0:
			mamod = 1.0
			mamin = 0.0
			
		if melee <= memin:
			melee = 0
		else:
			melee_hp -= 1
			
		if magic <= mamin:
			magic = 0
		else:
			magic_hp -= 1

		return melee * memod + magic * mamod

	func get_hud_string() -> String:
		return "\tame: " + str (melee_hp) + "\n\tama: " + str (magic_hp)
