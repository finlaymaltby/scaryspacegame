
extends StaticBody3D

# unicode character for backspace
const BACKSPACE: int = 8

var is_active: bool = true:
	set(value):
		if value == is_active:
			return
		elif value:
			enter()
		else:
			exit()
		is_active = value

var is_on: bool = true:
	set(value):
		if value == is_on:
			return
		elif value:
			turn_on()
		else:
			turn_off()
		is_on = value

@onready var in_zone: bool = false
@onready var buffer: String = ""
@onready var screen: RichTextLabel = $ScreenView/Text


@export_color_no_alpha var BG_COLOR: Color

func _ready() -> void:
	is_active = false
	is_on = false

# When the player is close enough to interact
func enter() -> void:
	Globals.WASD_ENABLED = false
# When the player leaves interaction zone
func exit() -> void:
	Globals.WASD_ENABLED = true
	
func turn_on() -> void:
	screen.text = "Begin:\n"
	buffer = ""
	$ScreenView/Background.color = BG_COLOR
	
func turn_off() -> void:
	screen.text = ""
	buffer = ""
	$ScreenView/Background.color = Color.BLACK

func _process(delta: float) -> void:
	if in_zone and Input.is_action_just_released("interact"):
		is_active = true
	
	if is_on:
		update_screen()
		
	if not is_active:
		return
		
	if len(buffer) > 0:
		if buffer.unicode_at(0) == BACKSPACE:
			if screen.text.right(1) != "\n":
				screen.text = screen.text.left(-1)
		else:
			screen.text += buffer[0]
		buffer = buffer.right(-1)
	
	

func _physics_process(delta: float) -> void:
	if len($Zone.get_overlapping_bodies()) > 0:
		var player: ThePlayer = $Zone.get_overlapping_bodies()[0]
		if (global_position - player.global_position).dot(-player.global_basis.z) > 0:
			in_zone = true
			return
	in_zone = false
	is_active = false

func _input(event: InputEvent) -> void:
	if not in_zone:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		is_on = not is_on
		
	if not is_on or not is_active:
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

func update_screen() -> void:
	var mesh: ArrayMesh = $ComputerMesh.mesh
	var mat: StandardMaterial3D = mesh.surface_get_material(2)
	mat.emission_texture = $ScreenView.get_texture()
