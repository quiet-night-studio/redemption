extends KinematicBody2D

signal health_changed(new_health)

enum State { NORMAL, RELOADING }

onready var reload_timer := $ReloadTimer
onready var hazzard_area := $HazzardArea
onready var aura_damage_timer := $AuraDamageTimer

var bullet: PackedScene = preload("res://scenes/Bullet.tscn")

var taking_aura_damage := false
var total_aura_damage := 0

var speed := 400
var reload_interval := 3
var current_state = State.NORMAL

func _ready() -> void:
	# warning-ignore:return_value_discarded
	hazzard_area.connect("area_entered", self, "_on_hazzard_area_entered")
	# warning-ignore:return_value_discarded
	reload_timer.connect("timeout", self, "_on_reload_timer_timeout")
	reload_timer.wait_time = reload_interval
	
	aura_damage_timer.wait_time = 1 # second
	# warning-ignore:return_value_discarded
	aura_damage_timer.connect("timeout", self, "_on_aura_damage_timer_timeout")

# Timeout for how long it takes to reload.
func _on_reload_timer_timeout() -> void:
	current_state = State.NORMAL
	GameManager.current_bullets = GameManager.magazine_size

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
	
func _physics_process(_delta: float) -> void:
	get_movement()

	if taking_aura_damage && aura_damage_timer.is_stopped():
		aura_damage_timer.start()
	
	if !taking_aura_damage && !aura_damage_timer.is_stopped():
		aura_damage_timer.stop()

	if Input.is_action_just_pressed("shoot"):
		if current_state == State.RELOADING:
			return

		GameManager.current_bullets -= 1
		if GameManager.current_bullets < 0:
			current_state = State.RELOADING
			reload_timer.start()
			for i in range(10):
				var n = 10
				var duration = 3.0
				var delay = duration / n
				GameManager.current_bullets +=1
				yield(get_tree().create_timer(delay),"timeout")
			return

		var mouse_world = get_global_mouse_position()
		var player_world = global_position

		var facing_direction = mouse_world - player_world
		var muzzle_position = facing_direction.normalized() * Vector2(40, 40)

		var b = bullet.instance() as RigidBody2D
		b.initial_position(global_position, muzzle_position)
		b.set_velocity(facing_direction.normalized())
		get_parent().add_child(b)

func kill() -> void:
	GameManager.current_health = GameManager.max_health
	var err = get_tree().reload_current_scene()
	if err != OK:
		print("error reloading scene: ", err)

func take_damage(damage_amount: int) -> void:
	GameManager.current_health -= damage_amount
	if GameManager.current_health <= 0:
		kill()
	emit_signal("health_changed", GameManager.current_health)

func _on_aura_damage_timer_timeout() -> void:
	if taking_aura_damage:
		take_damage(total_aura_damage)

func _on_hazzard_area_entered(_area: Area2D) -> void:
	take_damage(10)
