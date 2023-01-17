extends KinematicBody2D

export (PackedScene) var Bullet

const RADIUS = 30

var speed = 200
var velocity = Vector2.ZERO

func get_input() -> void:
	velocity = Vector2.ZERO
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

	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var player_pos = global_transform.origin
	var distance = player_pos.distance_to(mouse_pos)
	var mouse_dir = (mouse_pos-player_pos).normalized()

	if distance != RADIUS:
		mouse_pos = player_pos + (mouse_dir * RADIUS)

	$Muzzle.global_transform.origin = mouse_pos
	$Muzzle.look_at(get_global_mouse_position())

	get_input()
	# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func shoot() -> void:
	var cursor_pos = get_global_mouse_position()
	var distance = cursor_pos.distance_to(global_transform.origin)

	var b = Bullet.instance()
	
	if distance <= RADIUS:
		# Cursor is inside the circle
		print("Cursor is inside the circle.")

		var bullet_pos = global_transform.origin
		var angle = atan2(cursor_pos.y - global_transform.origin.y, cursor_pos.x - global_transform.origin.x)

	else:
		# Cursor is outside the circle
		b.transform = $Muzzle.global_transform

	get_tree().get_root().add_child(b)

func kill() -> void:
	var err = get_tree().reload_current_scene()
	if err != OK:
		print("error reloading scene: ", err)

func _on_Area2D_area_entered(area) -> void:
	if area.is_in_group("bullet"):
		return

	kill()
