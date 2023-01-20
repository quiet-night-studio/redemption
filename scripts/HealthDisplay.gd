extends Node2D

onready var healthbar = $HealthBar

func update_healthbar(value):
	healthbar.value -= value
