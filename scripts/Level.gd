extends Node2D

onready var _mobs = get_node("Mobs")
onready var _mob_spawn_location := $MobPath/MobSpawnLocation

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
	_mob_spawn_location.unit_offset = randf()

	var m = mob.instance()
	m.player = $Player
	m.navigation = $Navigation2D
	m.position = _mob_spawn_location.position

	_mobs.add_child(m)

