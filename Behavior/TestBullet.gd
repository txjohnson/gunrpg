class_name PlBullet
extends Area2D


export var heading:Vector2 
export var speed:float = 1000.0
export var max_travel:float = 1200.0
export var power = 10

var traveled = 0.0


func _ready():
	rotation = heading.angle()
	pass # Replace with function body.


func _physics_process(delta):
	var distance = speed * delta
	var motion = transform.x * speed * delta
	
	position += motion
	traveled += distance
	
	if traveled > max_travel:
		queue_free()


func _on_Bullet_body_entered(body):
	if body.has_method ('take_damage'):
		body.take_damage(power)
	queue_free()
