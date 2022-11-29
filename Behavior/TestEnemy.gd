extends KinematicBody2D
class_name TestEnemy

export var speed = 250

var player = null
var hitpoints = 100
var exp_points = 10
var melee_damage_amt  = 10
var magic_damage_amt  = 10

var game = null

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_parent().get_parent()

func _physics_process(delta):
	if player:
		var player_dir = (player.position - self.position).normalized()
		move_and_slide (speed * player_dir)	

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player":
			game .notify_player_hit (melee_damage_amt, magic_damage_amt)


func take_damage (howmuch):
	hitpoints -= howmuch
	if hitpoints <= 0:
		if game:
			game .notify_experience_prize (exp_points)
			game .notify_enemy_defeated ()
		queue_free()
