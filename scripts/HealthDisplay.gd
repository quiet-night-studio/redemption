extends Node2D

onready var healthbar = $HealthBar

func update_healthbar(value):
	healthbar.value -= value
	
func _process(delta):
	$Label.text = "Ammo: " + str(GameManager.current_bullets)
