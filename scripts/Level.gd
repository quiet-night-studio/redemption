extends Node2D

onready var _enemies = get_node("Enemies")
onready var _enemy_spawn_location := $EnemyPath/EnemySpawnLocation
onready var countdown_label = $CanvasLayer/CountDownTimer
onready var countdown_timer = $CountDownTimer

const COUNTDOWN_DURATION := 300 # 5 minutes

var enemy_scene: PackedScene = preload("res://scenes/Enemy.tscn")
var spawn_time := 0
var countdown := COUNTDOWN_DURATION

func _ready():
	countdown_timer.connect("timeout", self, "_on_countdown_timeout")

	update_countdown_label()

	randomize()
	spawn_time = randi() % 50 + 1

	var err = $Player.connect("update_health", $CanvasLayer/HealthDisplay, "update_healthbar")
	if err != OK:
		print("error connecting signal update_health: ", err)

func _process(delta):
	spawn_time -= delta

	if spawn_time <= 0:
		spawn()
		spawn_time = randi() % 50 + 1

func spawn():
	_enemy_spawn_location.unit_offset = randf()

	var e = enemy_scene.instance()
	e.player = $Player
	e.navigation = $Navigation2D
	e.position = _enemy_spawn_location.position

	_enemies.add_child(e)

func update_countdown_label() -> void:
	var minutes = countdown / 60
	var seconds = countdown % 60
	
	countdown_label.text = String(minutes).pad_zeros(2) + ":" + String(seconds).pad_zeros(2)

func _on_countdown_timeout() -> void:
	countdown -=1
	
	update_countdown_label()
	
	if countdown == 0:
		countdown_timer.stop()
