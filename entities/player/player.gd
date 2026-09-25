extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var lock: bool = true

# Reference to the camera pivot handle
@onready var camera_handle = $CameraHandle
@onready var camera = $CameraHandle/Camera3D

@export var mouse_sensitivity: float = 0.003

# Track camera pitch separately to prevent rotation drift
var camera_pitch: float = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle movement.
	var input_dir := Input.get_vector("action_left", "action_right", "action_forward", "action_backward")
	
	# transform.basis now updates correctly when the body rotates!
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		lock = !lock
		if lock:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# 1. Rotate the WHOLE CHARACTER BODY left/right (Y-axis)
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# 2. Accumulate up/down look angle (X-axis)
		camera_pitch -= event.relative.y * mouse_sensitivity
		camera_pitch = clamp(camera_pitch, deg_to_rad(-89.0), deg_to_rad(89.0))
		
		# 3. Apply pitch strictly to the CameraHandle (or Camera3D)
		camera_handle.rotation.x = camera_pitch
		camera_handle.rotation.y = 0.0
		camera_handle.rotation.z = 0.0
