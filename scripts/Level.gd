extends Node2D

onready var mobs = get_node("Mobs")

var mob: PackedScene = preload("res://scenes/Mob.tscn")
var spawn_time = 0

func _ready():
	randomize()
	spawn_time = randi() % 5 + 1
	
	var err = $Player.connect("update_health", $CanvasLayer/HealthDisplay, "update_healthbar")
	if err != OK:
		print("error connecting signal update_health: ", err)

func _process(delta):
	spawn_time -= delta

	if spawn_time <= 0:
		spawn()
		spawn_time = randi() % 5 + 1

func spawn():
	var m = mob.instance()
	m.position = Vector2(randi() % 1024, randi() % 600)
	mobs.add_child(m)
