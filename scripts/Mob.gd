extends KinematicBody2D

var speed = 100
var player = KinematicBody2D

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

	$Sprite.modulate = Color(randf(), randf(), randf())

func _physics_process(delta: float) -> void:
	# Flip the asset horizontally based on the player's position.
	if global_position < player.global_position:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

	position = position.move_toward(player.position, speed * delta)	
	move_and_collide(Vector2.ZERO)
