extends RigidBody2D

var lifetime = 2
var speed = 800

func _physics_process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func set_velocity(direction: Vector2) -> void:
	linear_velocity = direction * speed

func initial_position(shooter_position: Vector2, muzzle_position: Vector2) -> void:
	global_position = shooter_position + muzzle_position

func _on_EnvironmentArea_body_entered(body: Node) -> void:
	# A RigidBody2D extends from Physics2D, which is also capture by this signal.
	# Ignore itself when added to the scene.
	if body != self:
		queue_free()

func _on_HazzardArea_area_entered(_area: Area2D) -> void:
	queue_free()
