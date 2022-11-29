extends Node2D

var motion = Vector2 (0, 0)
var speed:float = 1000
var bullet = preload("res://Scenes/TestBullet.tscn")

var player_can_shoot_main = true
var player_is_shooting_main = false

func shoot_main_weapon ():
	var bi = bullet.instance()
	bi.position = $Icon/Sight/Position2D.global_position
	bi.heading  = Vector2(1,0).rotated($Icon/Sight.rotation)
	bi.speed    = 1500
	$Bullets.add_child (bi)
	player_can_shoot_main = false
	$Icon/MainGunCoolDown.start()
	print("playing audio")
	$MainWeaponAttack.play()

func _input(event):
	if event.is_action_pressed("right_trigger"):
		player_is_shooting_main = true

	if event.is_action_released("right_trigger"):
		player_is_shooting_main = false
	
	
func _process(delta):
	var aim_dir = Vector2(
			Input.get_action_strength("right_right") - Input.get_action_strength("right_left"),
			Input.get_action_strength("right_down") - Input.get_action_strength("right_up")).clamped(1)

	$Icon/Sight .rotation = aim_dir.angle()
		
	var velocity = Vector2(
			Input.get_action_strength("left_right") - Input.get_action_strength("left_left"),
			Input.get_action_strength("left_down") - Input.get_action_strength("left_up")).clamped(1)
	
	motion = velocity *speed
	$Icon.position += motion * delta

	if player_can_shoot_main and player_is_shooting_main:
		shoot_main_weapon()
	pass

func _ready():
	pass # Replace with function body.



func _on_MainGunCoolDown_timeout():
	$Player/MainWeaponAttack .stop()
	player_can_shoot_main = true
