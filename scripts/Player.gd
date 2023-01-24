extends KinematicBody2D

export (PackedScene) var Bullet

signal update_health

var max_health = 100

const RADIUS = 30

onready var eyes = $Eyes

var speed = 200

func _physics_process(_delta: float) -> void:
	var mouse_world = get_global_mouse_position()
	var player_world = global_position

	var facing_direction = mouse_world - player_world
	var muzzle_position = facing_direction.normalized() * Vector2(50, 50)
	var eye_position = facing_direction.normalized() * Vector2(5, 5)

	eyes.global_position = global_position + eye_position	

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

	if Input.is_action_just_pressed("shoot"):
		var b = Bullet.instance() as RigidBody2D
		get_tree().get_root().add_child(b)

		b.global_position = global_position + muzzle_position
		b.set_velocity(facing_direction.normalized())

func kill() -> void:
	var err = get_tree().reload_current_scene()
	if err != OK:
		print("error reloading scene: ", err)

func _on_Area2D_area_entered(_area) -> void:
	max_health -= 10
	emit_signal("update_health", 10)

	if max_health <= 0:
		kill()
