extends Node

# Temporary Cursor Image
var cross_cursor = load("res://assets/cross_cursor.png")

func _ready():
	Input.set_custom_mouse_cursor(cross_cursor, Input.CURSOR_ARROW, Vector2(25,25))
#								   Var Name,      Default Cursor,  Hotspot/area clicked
