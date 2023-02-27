extends KinematicBody2D

var player := KinematicBody2D
var navigation := Navigation2D
var velocity := Vector2.ZERO

var types = {
	0: {
		"speed": 100.0,
		"health": 100,
		"damage": 10.0,
		"damage_aura": 0,
		"color": Color(1, 1, 0, 1)
	},
	1: {
		"speed": 80.0,
		"health": 180,
		"damage": 50.0,
		"damage_aura": 10,
		"color": Color(0.721569, 0.52549, 0.0431373, 1)
	},
	2: {
		"speed": 180.0,
		"health": 200,
		"damage": 10.0,
		"damage_aura": 90,
		"color": Color(1, 0.270588, 0, 1)
	}
}

# Characteristics
var speed := 0.0
var damage := 0
var health := 0
var damage_aura := 0.0
var color := Color(0,0,0,0)

onready var agent := $NavigationAgent2D
onready var pathfinding_timer := $PathfindingTimer
onready var sprite := $Sprite

func spawn_type() -> void:
	# Specify which enemy should spawn based on "something".
	# For now I will randomise.
	randomize()
	var i := randi() % 3

	speed = types[i].speed
	health = types[i].health
	damage = types[i].damage
	damage_aura = types[i].damage_aura
	color = types[i].color

func _ready() -> void:
	spawn_type()

	var err := pathfinding_timer.connect("timeout", self, "_on_PathfindingTimer_timeout")
	if err != OK:
		print("unable to connect to the pathfinding timeout signal: ", err)

	$Sprite.modulate = color
	agent.set_navigation(navigation)

	_on_PathfindingTimer_timeout()

func _physics_process(delta: float) -> void:
	if agent.is_navigation_finished():
		return

	var direction := global_position.direction_to(agent.get_next_location())

	var desired_velocity := direction * speed
	var steering := (desired_velocity - velocity) * delta * 4.0
	velocity += steering

	sprite.rotation = velocity.angle()

	velocity = move_and_slide(velocity)

func _on_PathfindingTimer_timeout() -> void:
	agent.set_target_location(player.global_position)

func _on_HazzardArea_body_entered(_body: Node) -> void:
	queue_free()
