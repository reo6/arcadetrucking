extends CharacterBody3D

@export var acceleration: float = 10.0
@export var brake_intensity: float = 5.0
@export var rotation_speed: float = 1.5
@export var gravity: float = 9.8
@export var max_speed: float = 30.0

var current_speed: float = 0.0

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Get input direction
	var input_forward = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	var input_rotation = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
	
	# Handle rotation
	if input_rotation != 0:
		rotate_y(-input_rotation * rotation_speed * delta)
	
	# Handle acceleration and braking
	if input_forward > 0:
		# Accelerate forward
		current_speed = move_toward(current_speed, max_speed, acceleration * delta)
	elif input_forward < 0:
		# Accelerate backward
		current_speed = move_toward(current_speed, -max_speed / 2, acceleration * delta)
	else:
		# No input, gradually slow down
		current_speed = move_toward(current_speed, 0, brake_intensity * delta)
	
	# Apply movement in the direction the vehicle is facing
	var direction = -global_transform.basis.z
	velocity.z = direction.x * current_speed
	velocity.x = direction.z * current_speed
	
	move_and_slide()
