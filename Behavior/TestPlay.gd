extends Node2D

var plexp    :int   = 0
var plhealth :float = 100
var plarmor         = Defs.Armor .new (100, 1, 0.10, 100, 1, 0.10)
var level           = 0
var spawns_left     = 5

var enemy = preload("res://Scenes/TestEnemy.tscn")
var rnd   = RandomNumberGenerator.new()

func _ready():
	rnd.randomize()
	$SpawnTimer.start()
	update_hud()

func spawn_enemy ():
	var num_spawners = $Spawners.get_child_count()
	var which = rnd.randi_range(0, num_spawners - 1)
	var spawner = $Spawners.get_child(which)
	print (which, " and ", spawner)

	var m = spawner .spawn_enemy (level, $Player)
	spawns_left -= 1
	$Enemies.add_child(m)
	pass

func _on_SpawnTimer_timeout():
	print("creating enemy")
	spawn_enemy()
	if spawns_left > 0:
		$SpawnTimer.start()

func update_hud ():
	var data = "health: " + str(plhealth) + "\nexp: " + str(plexp) + "\n";
	data += plarmor .get_hud_string ()
	$Player/Camera2D/HUD/Exp.text = data
	$Player/Camera2D/HUD/Level.text = "LEVEL: " + str (level + 1)


func notify_experience_prize (amt):
	plexp += amt
	update_hud ()

func notify_player_hit (melee :int, magic :int):
	var actual = plarmor .take_damage (melee, magic)
	plhealth -= actual
	update_hud ()
	if plhealth < 0.0:
		get_tree().change_scene("res://Scenes/TestPlay.tscn")
	pass

func notify_enemy_defeated ():
	if spawns_left == 0 and $Enemies.get_child_count() == 1:
		level += 1
		spawns_left = 5 * level
		update_hud()
		$SpawnTimer.wait_time -= 0.5
		$SpawnTimer.start()
