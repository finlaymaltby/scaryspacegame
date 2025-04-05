
extends StaticBody3D

# unicode character for backspace
const BACKSPACE: int = 8

var is_active: bool:
	set(value):
		if value:
			enter()
		else:
			exit()
		is_active = value

var is_on: bool:
	set(value):
		if value:
			turn_on()
		else:
			turn_off()
		is_on = value

var is_user: bool:
	set(value):
		if is_user == value:
			return
		buffer = ""
		if value:
			buffer += " "
			
		else:
			run_input()
		is_user = value

@onready var buffer: String = ""
@onready var input: String = ""
@onready var screen: RichTextLabel = $ScreenView/Text


func _ready() -> void:
	is_active = false
	is_on = false
	is_user = false
	update_screen()

# When the player is close enough to interact
func enter() -> void:
	Globals.WASD_ENABLED = false
# When the player leaves interaction zone
func exit() -> void:
	Globals.WASD_ENABLED = true
	
func turn_on() -> void:
	is_user = false
	screen.text = ""
	buffer = "initialising terminal session at %02d:%02d as 'user'\n~" % [Globals.game_hours, Globals.game_minutes]
	$ScreenView/Background.color = Color(0,8.0/255.0,0)
	$BufferTimer.paused = false;
	
func turn_off() -> void:
	screen.text = ""
	buffer = ""
	$ScreenView/Background.color = Color.BLACK
	$BufferTimer.paused = true;
	is_active = false

func _process(delta: float) -> void:
	if $Zone.in_zone and Input.is_action_just_released("interact"):
		is_active = true
	elif not $Zone.in_zone:
		is_active = false
	
	if is_on:
		update_screen()

func _input(event: InputEvent) -> void:
	if not $Zone.in_zone:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		is_on = not is_on
		
	if not is_on or not is_active:
		return
		
	if event is InputEventKey and event.pressed and is_user:
		if event.key_label == KEY_ENTER:
			buffer += "\n"
			
		elif event.key_label == KEY_SPACE:
			buffer += " "
			
		elif event.key_label == KEY_BACKSPACE:
			buffer += char(8) # code for backspace

		elif event.key_label >= KEY_A and event.key_label <= KEY_Z:
			buffer += OS.get_keycode_string(event.key_label).to_lower()

func update_screen() -> void:
	var mesh: ArrayMesh = $ComputerMesh.mesh
	var mat: StandardMaterial3D = mesh.surface_get_material(2)
	mat.emission_texture = $ScreenView.get_texture()
	$ScreenView/TextureRect.texture.noise.seed += 1

func _on_buffer_timer_timeout() -> void:
	if len(buffer) > 0:
		var ch = buffer[0]
		var unicode = buffer.unicode_at(0)
		
		if unicode == BACKSPACE:
			if screen.text.right(2) != "\n":
				screen.text = screen.text.left(-1)
				
			if is_user and len(input) > 0:
				input= input.left(-1)
		else:
			screen.text += ch
			if is_user:
				input += ch
		buffer = buffer.right(-1)
		
		if unicode == "~".unicode_at(0):
			is_user = true
		elif unicode == "\n".unicode_at(0):
			is_user = false

func run_input() -> void:
	input = input.strip_edges()
	var args := input.split(" ", false)
	
	if input == "":
		buffer += "~"
		input = ""
		return
	elif input == "clear":
		screen.text = ""
		buffer = "~"
	elif input in ["hello", "hi", "howdy", "gday", "greetings"]:
		buffer += "hello"
	elif input in "fuck you":
		buffer += "no fuck you"
	elif input == "time":
		buffer += "%02d:%02d" % [Globals.game_hours, Globals.game_minutes]
	elif input == "users":
		buffer += "1. user [CURRENT]\n2. admin"
	elif args[0] in ["cd", "ls", "cat", "rm", "pwd", "mkdir", "touch"]:
		buffer += "nice try smartypants"
	elif args[0] in ["python", "python3"]:
		buffer += "wtf is wrong with you"
	elif args[0] == "echo":
		if len(args) > 1:
			buffer += " ".join(args.slice(1))
	elif args[0] == "status":
		buffer += "Instance-ID: [STATUS]\n"
		buffer += "A: [STANDBY]\nB: [LOCKED]\nC: [ACTIVE]"
	elif args[0] == "activate":
		if len(args) == 1:
			buffer += "error: activate command requires a specified target instance\n"
			buffer += "usage: activate [Instance-ID]"
		elif args[1] == "a":
			buffer += "AAAAA WHAT YOU DOING"
		elif args[1] == "b":
			buffer += "ACCESS DENIED\n"
			buffer += "error: requires administrator privileges\n"
			buffer += "hint: login as admin"
		elif args[1] == "c":
			buffer += "error: specified target instance is already active"
		else:
			buffer += "error: specified target instance does not exist\n"
			buffer += "usage: activate [Instance-ID]\n"
			buffer += "hint: use status command to view valid instances"
	elif args[0] == "login":
		if len(args) == 1:
			buffer += "error: login command requires a username and password\n"
			buffer += "usage: login [username] [password]\n"
			buffer += 'hint: password may be optional'
		elif args[1] == "user":
			buffer += "successfully signed in as user"
		elif args[1] == "admin" and len(args) == 2:
			buffer += "ACCESS DENIED\n"
			buffer += "error: admin access requires password"
		elif args[1] == "admin" and args[2] == "password":
			buffer += "successfully signed in as admin"
		elif args[1] == "admin":
			buffer += "ACCESS DENIED\n"
			buffer += "error: incorrect password"
		else:
			buffer += "error: unrecognised username"
			buffer += "hint: use users command to view usernames"
	else:
		buffer += "unrecognised command '%s'" % input
		
	buffer += "\n~"
	input = ""

func argument_error() -> void:
	buffer += "incorrect arguments"
