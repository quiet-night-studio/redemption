extends KinematicBody2D

var speed := 100.0
var player := KinematicBody2D
var velocity := Vector2.ZERO

onready var agent := $NavigationAgent2D
onready var timer := $Timer
onready var sprite := $Sprite

func _ready() -> void:
	timer.connect("timeout", self, "update_pathfinding")
	
	player = get_tree().get_nodes_in_group("player")[0]

	$Sprite.modulate = Color(randf(), randf(), randf())

	agent.set_navigation(get_tree().get_root().get_node("Level").get_node("Navigation2D"))
	update_pathfinding()

func _physics_process(delta: float) -> void:
	if agent.is_navigation_finished():
		return

	var direction := global_position.direction_to(agent.get_next_location())

	var desired_velocity := direction * speed
	var steering := (desired_velocity - velocity) * delta * 4.0
	velocity += steering

	sprite.rotation = velocity.angle()

	velocity = move_and_slide(velocity)

func update_pathfinding() -> void:
	agent.set_target_location(player.global_position)

func _on_HazzardArea_body_entered(body: Node) -> void:
	queue_free()
