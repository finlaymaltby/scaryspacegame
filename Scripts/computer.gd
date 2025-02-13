extends StaticBody3D

# unicode character for backspace
const BACKSPACE: int = 8

@onready var in_zone: bool = false

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
	$Screen/Text.text = "Begin:\n"
	buffer = ""
	
func turn_off() -> void:
	$Screen/Text.text = ""
	buffer = ""

func _process(delta: float) -> void:
	if in_zone and Input.is_action_just_released("interact"):
		is_active = true
		
	if len(buffer) > 0:
		if buffer.unicode_at(0) == BACKSPACE:
			$Screen/Text.text = $Screen/Text.text.left(-1)
		else:
			$Screen/Text.text += buffer[0]
		buffer = buffer.right(-1)


func _physics_process(delta: float) -> void:
	if len($Zone.get_overlapping_bodies()) > 0:
		var player: ThePlayer = $Zone.get_overlapping_bodies()[0]
		if (global_position - player.global_position).dot(-player.global_basis.z) > 0:
			in_zone = true
			return
	
	in_zone = false

func _input(event: InputEvent) -> void:
	if not is_active:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		is_on = not is_on
		
	if not is_on:
		return
		
	if event is InputEventKey and event.pressed:
		if event.key_label == KEY_ENTER:
			buffer += "\n"
			
		elif event.key_label == KEY_SPACE:
			buffer += " "
			
		elif event.key_label == KEY_BACKSPACE:
			buffer += char(8) # code for backspace

		elif event.key_label >= KEY_A and event.key_label <= KEY_Z:
			buffer += OS.get_keycode_string(event.key_label)
