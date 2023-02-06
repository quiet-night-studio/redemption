extends KinematicBody2D

var _speed := 100.0
var _player := KinematicBody2D
var _velocity := Vector2.ZERO

onready var _agent := $NavigationAgent2D
onready var _timer := $Timer
onready var _sprite := $Sprite

func _ready() -> void:
	_timer.connect("timeout", self, "_update_pathfinding")
	
	_player = get_tree().get_nodes_in_group("player")[0]

	$Sprite.modulate = Color(randf(), randf(), randf())

	_agent.set_navigation(get_tree().get_root().get_node("Level").get_node("Navigation2D"))
	_update_pathfinding()

func _physics_process(delta: float) -> void:
	if _agent.is_navigation_finished():
		return

	var direction := global_position.direction_to(_agent.get_next_location())

	var desired_velocity := direction * _speed
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering

	_sprite.rotation = _velocity.angle()

	_velocity = move_and_slide(_velocity)

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("bullet") or body.is_in_group("player"):
		Audio.death()
		queue_free()

func _update_pathfinding() -> void:
	_agent.set_target_location(_player.global_position)
