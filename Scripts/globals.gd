extends Node

# degrees per pixel of mouse movement
var MOUSE_SENSITIVITY : float = 0.1


func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		get_tree().quit()
