extends Node2D

onready var enemies = get_node("Enemies")
onready var enemy_spawn_location := $EnemyPath/EnemySpawnLocation

# The level countdown.
onready var countdown_label = $CanvasLayer/CountDownTimer
onready var countdown_timer = $CountDownTimer

# The time interval between enemy spawns.
onready var spawn_timer = $SpawnTimer

onready var player := $Player

const COUNTDOWN_DURATION := 300 # 5 minutes
const MAX_ENEMIES := 100

var enemy_scene: PackedScene = preload("res://scenes/Enemy.tscn")
var spawn_interval := 5 # seconds
var num_enemies_spawned := 0
var time_elapsed := 0.0

# The countdown value will be updated.
var countdown := COUNTDOWN_DURATION

func _ready():
	# warning-ignore:return_value_discarded
	countdown_timer.connect("timeout", self, "_on_countdown_timeout")
	# warning-ignore:return_value_discarded
	spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
	# warning-ignore:return_value_discarded
	player.connect("health_changed", $CanvasLayer/HealthDisplay, "_on_Player_health_changed")

	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()

	update_countdown_label()

func _process(delta):
	# Update the current time elapsed
	time_elapsed += delta

func update_countdown_label() -> void:
	# warning-ignore:integer_division
	var minutes = countdown / 60
	var seconds = countdown % 60

	countdown_label.text = String(minutes).pad_zeros(2) + ":" + String(seconds).pad_zeros(2)

func spawn() -> void:
	enemy_spawn_location.unit_offset = randf()

	var e = enemy_scene.instance()
	e.player = $Player
	e.navigation = $Navigation2D
	e.position = enemy_spawn_location.position

	enemies.add_child(e)

func _on_spawn_timer_timeout() -> void:
	if num_enemies_spawned >= MAX_ENEMIES:
		return

	num_enemies_spawned += 1

	if time_elapsed <= 20:
		spawn_interval = 5
	elif time_elapsed <= 40:
		spawn_interval = 4
	elif time_elapsed <= 60:
		spawn_interval = 3
	elif time_elapsed <= 80:
		spawn_interval = 2
	else:
		spawn_interval = 1

	spawn_timer.wait_time = spawn_interval

	spawn()

func _on_countdown_timeout() -> void:
	countdown -=1

	update_countdown_label()

	if countdown == 0:
		countdown_timer.stop()

# who is it about?
# what do they want?
# why can't they get it?
# what do they do about that?
# why doen't that work?
# how does it end?
