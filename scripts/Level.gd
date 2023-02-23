extends Node2D

onready var _enemies = get_node("Enemies")
onready var _enemy_spawn_location := $EnemyPath/EnemySpawnLocation

var enemy: PackedScene = preload("res://scenes/Enemy.tscn")
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
	_enemy_spawn_location.unit_offset = randf()

	var e = enemy.instance()
	e.player = $Player
	e.navigation = $Navigation2D
	e.position = _enemy_spawn_location.position

	_enemies.add_child(e)

