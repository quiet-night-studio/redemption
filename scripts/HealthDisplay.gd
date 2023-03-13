extends Node2D

onready var healthbar = $HealthBar
onready var ammocount = $AmmoCount
	
func _process(_delta):
	ammocount.value = GameManager.current_bullets

func update_healthbar(value):
	healthbar.value -= value
	print("healthbar value: " + str(value))

func _on_Player_health_changed(new_health):
	healthbar.value = new_health
	print("Player Health: " + str(new_health))
