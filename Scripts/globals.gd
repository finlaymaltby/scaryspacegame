extends Node


# degrees per pixel of mouse movement
var MOUSE_SENSITIVITY : float = 0.1

var WASD_ENABLED : bool
var MOVE_DIR : Vector2

func _ready() -> void:
	start()

func start() -> void:
	WASD_ENABLED = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
