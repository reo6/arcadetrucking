extends VehicleBody3D

@export var MAX_STEER = 0.5
@export var ENGINE_POWER = 300

func _physics_process(delta):
	steering = move_toward(steering, Input.get_axis("turn_right", "turn_left") * MAX_STEER, delta * 10)
	engine_force = Input.get_axis("move_backward", "move_forward") * ENGINE_POWER
