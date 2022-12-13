extends Node


export var  player_path :NodePath
export var  bullets_path :NodePath

var bullet = preload("res://Scenes/TestBullet.tscn")

onready var player = get_node (player_path)
onready var bullets = get_node (bullets_path)

onready var sight  = player .get_node('Sight')
onready var sight_pos = player .get_node ('Sight/SitePosition')
onready var mtimer = player .get_node('MainCoolDown')
onready var mainweaponfx = player.get_node('MainWeaponAttack')
onready var shape = player.get_node('Sprite')

var motion = Vector2 (0.0, 0.0)
var MAX_SPEED    = 500
var ACCELERATION = 10000

export (bool) var use_keyboard = true

var player_can_shoot_main = true
var player_is_shooting_main = false

func shoot_main_weapon ():
	mainweaponfx.stop()
	var bi = bullet.instance()
	bi.position = sight_pos.global_position
	bi.heading  = Vector2(1,0).rotated(sight.rotation)
	bi.speed    = 1500
	bullets.add_child (bi)
	player_can_shoot_main = false
	mainweaponfx.play()
	mtimer.start()

func _input(event):
	
	if use_keyboard:
		
		if event.is_action_pressed("FIRE_MAIN"):
			player_is_shooting_main = true

		if event.is_action_released("FIRE_MAIN"):
			player_is_shooting_main = false
	else:
		if event.is_action_pressed("right_trigger"):
			player_is_shooting_main = true

		if event.is_action_released("right_trigger"):
			player_is_shooting_main = false


func _physics_process(delta):
	var aim_dir = Vector2(0.0, 0.0)
	var movement
	
	if use_keyboard:
		aim_dir =  Input.get_last_mouse_speed().normalized()
		
		var movex = 0.0
		var movey = 0.0
		
		if Input.is_action_pressed("ui_left"):  movex = -1.0
		if Input.is_action_pressed("ui_right"): movex = 1.0
		if Input.is_action_pressed("ui_up"):    movey = -1.0
		if Input.is_action_pressed("ui_down"):  movey = 1.0
		
		movement = Vector2 (movex, movey).normalized()
		pass
	else:
		aim_dir = Vector2(
			Input.get_action_strength("right_right") - Input.get_action_strength("right_left"),
			Input.get_action_strength("right_down") - Input.get_action_strength("right_up")).clamped(1)
		
		movement = Vector2(
			Input.get_action_strength("left_right") - Input.get_action_strength("left_left"),
			Input.get_action_strength("left_down") - Input.get_action_strength("left_up")).normalized()

	sight .rotation = aim_dir.angle()
	
	if movement == Vector2.ZERO:
		var friction = ACCELERATION * delta
		if motion.length() > friction:
			motion -= motion.normalized() * friction
		else:
			motion = Vector2.ZERO
	else:
		motion += movement * ACCELERATION * delta
		motion = motion .clamped (MAX_SPEED)
	
	var move_angle = round (rad2deg (motion.angle())) + 180
	var aim_angle = round (rad2deg (aim_dir.angle())) + 180
	
	var idle = ""
	var move = ""
	
	if motion.length() == 0:
		idle = "idle_"
		
	if aim_dir.length() != 0:
		if aim_angle >= 135 and aim_angle <= 225:
			move = "right"
		elif aim_angle <= 45 or aim_angle >= 315:
			move = "left"
		elif aim_angle > 45 and aim_angle < 135:
			move = "up"
		else:
			move = "down"
	else:
		if move_angle >= 135 and move_angle <= 225:
			move = "right"
		elif move_angle <= 45 or move_angle >= 315:
			move = "left"
		elif move_angle > 45 and move_angle < 135:
			move = "up"
		else:
			move = "down"

	shape.animation = idle + move
	
	motion = player.move_and_slide (motion)

	if player_can_shoot_main and player_is_shooting_main:
		shoot_main_weapon()


func _ready():
	pass # Replace with function body.



func _on_MainCoolDown_timeout():
	mainweaponfx.stop()
	player_can_shoot_main = true
