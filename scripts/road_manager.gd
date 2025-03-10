extends Node3D

@export var road_scene: PackedScene = preload("res://scenes/road.tscn")
@export var initial_roads := 5  # Number of roads to spawn on each side
@export var road_spacing := 20.0  # Exact spacing from original scene
@export var spawn_distance := 50.0  # Distance ahead to spawn new roads

var player: Node3D
var last_spawn_x := 0.0

func _ready():
	# Use call_deferred to ensure player exists
	call_deferred("initialize_player")

func initialize_player():
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_error("Player not found in 'player' group!")
		return
	
	# Initialize starting roads relative to player position
	var start_x = floor(player.global_position.x / 20.0) * 20.0
	for i in range(-initial_roads, initial_roads):
		spawn_road(start_x + i * 20.0)
	last_spawn_x = start_x + initial_roads * 20.0

func _process(_delta):
	if not player:
		return  # Skip if player not found
	
	# Check road spawning based on player's X position
	if player.global_position.x > last_spawn_x - spawn_distance:
		spawn_road(last_spawn_x + 20.0)
		last_spawn_x += 20.0

func spawn_road(x_position: float):
	var new_road = road_scene.instantiate()
	# Add proper positioning based on original road spacing
	new_road.global_transform = Transform3D(
		Vector3(2, 0, 0),
		Vector3(0, 2, 0),
		Vector3(0, 0, 2),
		Vector3(x_position, 0, 0)
	)
	add_child(new_road)
