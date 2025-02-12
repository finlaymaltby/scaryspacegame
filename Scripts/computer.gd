extends StaticBody3D

@onready var is_active: bool = false:
	set(value):
		if value == is_active:
			return
		elif value:
			enter()
		else:
			exit()
		is_active = value

@onready var is_on: bool = false:
	set(value):
		if value == is_on:
			return
		elif value:
			turn_on()
		else:
			turn_off()
		is_on = value
		
@onready var buffer: String = ""


# When the player is close enough to interact
func enter() -> void:
	Globals.WASD_ENABLED = false
	set_process(true)

# When the player leaves interaction zone
func exit() -> void:
	Globals.WASD_ENABLED = true
	set_process(false)
	
func turn_on() -> void:
	$ScreenText.text = "Begin:\n"
	buffer = ""
	
func turn_off() -> void:
	$ScreenText.text = ""
	buffer = ""

func _process(delta: float) -> void:
	if Input.is_action_just_released("left_click"):
		is_on = not is_on
		
	if len(buffer) > 0:
		$ScreenText.text += buffer[0]
		buffer = buffer.substr(1)


func _physics_process(delta: float) -> void:
	if len($Zone.get_overlapping_bodies()) > 0:
		var player: ThePlayer = $Zone.get_overlapping_bodies()[0]
		if (global_position - player.global_position).dot(-player.global_basis.z) > 0:
			is_active = true
			return
	
	is_active = false

func _input(event: InputEvent) -> void:
	if not is_active:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_on = not is_on
		
	if not is_on:
		return
		
	if event is InputEventKey and event.pressed:
		if event.key_label == KEY_ENTER:
			buffer += "\n"
		if event.key_label == KEY_SPACE:
			buffer += " "
		if event.unicode >= "A".unicode_at(0) and event.unicode <= "z".unicode_at(0):
			buffer += String.chr(event.unicode)

		
