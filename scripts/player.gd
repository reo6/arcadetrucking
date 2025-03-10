extends CharacterBody3D

@export var acceleration: float = 5.0
@export var brake_intensity: float = 3.0
@export var strafe_speed: float = 10.0  # Speed for sideways movement
@export var gravity: float = 9.8
@export var max_speed: float = 30.0

var current_speed: float = 0.0

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Get input direction
	var input_forward = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	var input_strafe = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	
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
	
	# Get the forward and right vectors
	var forward_direction = -global_transform.basis.z
	var side_direction = global_transform.basis.x
	
	# Calculate forward movement
	var forward_movement = Vector3(
		forward_direction.x * current_speed,
		0,
		forward_direction.z * current_speed
	)
	
	# Calculate strafe movement (sideways)
	var strafe_movement = Vector3(
		side_direction.x * input_strafe * strafe_speed,
		0,
		side_direction.z * input_strafe * strafe_speed
	)
	
	# Combine movements
	var total_movement = forward_movement + strafe_movement
	
	# Apply to velocity
	velocity.z = total_movement.x
	velocity.x = total_movement.z
	
	move_and_slide()
