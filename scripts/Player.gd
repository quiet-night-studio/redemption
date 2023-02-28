extends KinematicBody2D

signal update_health

enum State { NORMAL, RELOADING }

onready var reload_timer := $ReloadTimer
onready var info_label := $Info

var bullet: PackedScene = preload("res://scenes/Bullet.tscn")

var max_health := 100
var speed := 200
var magazine_size := 10
var reload_interval := 3
var current_bullets := 0
var shooting := false
var reloading := false
var current_state = State.NORMAL

func _ready() -> void:
	reload_timer.connect("timeout", self, "_on_reaload_timer_timeout")
	reload_timer.wait_time = reload_interval

# Timeout for how long it takes to reload.
func _on_reaload_timer_timeout() -> void:
	info_label.text = ""
	current_state = State.NORMAL

func get_movement() -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1

	# Make sure diagonal movement isn't faster.
	velocity = velocity.normalized() * speed

	# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func _physics_process(delta: float) -> void:
	get_movement()

	if Input.is_action_just_pressed("shoot"):
		if current_state == State.RELOADING:
			info_label.text = "still reloading!!!"
			return

		current_bullets += 1
		if current_bullets >= magazine_size:
			info_label.text = "reloading..."
			current_bullets = 0
			current_state = State.RELOADING
			reload_timer.start()
			return

		var mouse_world = get_global_mouse_position()
		var player_world = global_position

		var facing_direction = mouse_world - player_world
		var muzzle_position = facing_direction.normalized() * Vector2(35, 35)

		var b = bullet.instance() as RigidBody2D
		b.global_position = global_position + muzzle_position
		b.set_velocity(facing_direction.normalized())

		get_parent().add_child(b)

func kill() -> void:
	var err = get_tree().reload_current_scene()
	if err != OK:
		print("error reloading scene: ", err)

func _on_Area2D_area_entered(_area) -> void:
	max_health -= 10
	emit_signal("update_health", 10)

	if max_health <= 0:
		kill()
