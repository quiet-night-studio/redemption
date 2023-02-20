extends RigidBody2D

var lifetime = 2
var speed = 300

func new(position) -> void:
	global_position = position

func _physics_process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func set_velocity(direction: Vector2) -> void:
	linear_velocity = direction * speed

func _on_Area2D_area_entered(_area: Area2D) -> void:
	queue_free()

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "TileMap":
		queue_free()
