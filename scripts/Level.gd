extends Node2D

var mob: PackedScene = preload("res://scenes/Mob.tscn")
var spawn_time = 0

func _ready():
	spawn_time = randi() % 5 + 1

func _process(delta):
	spawn_time -= delta

	if spawn_time <= 0:
		spawn()
		spawn_time = randi() % 5 + 1

func spawn():
	var m = mob.instance()
	m.position = Vector2(randi() % 1024, randi() % 600)
	add_child(m)
