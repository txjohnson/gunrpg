extends Area2D

var enemy = preload("res://Scenes/TestEnemy.tscn")

func _ready():
	pass # Replace with function body.


func spawn_enemy (level :int, target):
	var m = enemy.instance()
	m.hitpoints = 100 + (level * 25)
	m.exp_points = 10 + (level * 15)
	m.position = position
	m.player = target
	return m
