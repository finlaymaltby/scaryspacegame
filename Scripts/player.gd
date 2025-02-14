extends CharacterBody3D
class_name ThePlayer


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _process(delta: float) -> void:
	$CanvasLayer/FPS.text = str(round(1/delta*10)/10)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Globals.WASD_ENABLED and Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Globals.WASD_ENABLED:
		input_dir += Input.get_vector("Left", "Right", "Forward", "Backward")
		
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _input(event: InputEvent):
	var mouse := event as InputEventMouseMotion
	if not mouse:
		return
	rotate_y(deg_to_rad(-mouse.relative.x * Globals.MOUSE_SENSITIVITY))
	$Cam.rotate_x(deg_to_rad(-mouse.relative.y * Globals.MOUSE_SENSITIVITY))
	 
	$Cam.rotation_degrees.x = clampf($Cam.rotation_degrees.x, -70, 70)
	
	
