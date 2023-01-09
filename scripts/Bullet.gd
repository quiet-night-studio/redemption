extends Area2D

var speed = 750
var lifetime = 2

func _physics_process(delta):
	position += transform.x * speed * delta

	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _on_Bullet_area_entered(_area: Area2D) -> void:
		queue_free()
