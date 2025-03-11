extends Node3D

@export var player: CharacterBody3D
@export var spawn_distance: float = 100.0
@export var despawn_distance: float = 200.0

var road_scene = preload("res://scenes/road.tscn")
var roads = []
var road_length: float

func _ready():
	# Calculate road length from existing instance
	var temp_road = road_scene.instantiate()
	# Get the MeshInstance3D from the road scene structure
	var mesh_instance = temp_road.get_node("RoadObject") as MeshInstance3D
	if mesh_instance:
		var aabb = mesh_instance.mesh.get_aabb()
		road_length = aabb.size.x * mesh_instance.scale.x
	else:
		push_error("Could not find RoadObject MeshInstance3D in road scene")
		road_length = 20.0  # Fallback value
	temp_road.queue_free()
	
	# Initialize with existing road
	var initial_road = $Road
	roads.append(initial_road)

func _process(delta):
	if not player:
		return
	
	var player_x = player.global_position.x
	
	# Spawn new roads ahead
	var last_road = roads[-1]
	var last_road_end = last_road.global_position.x + road_length
	if player_x + spawn_distance > last_road_end:
		spawn_road(last_road_end)
	
	# Despawn old roads behind
	for road in roads.duplicate():
		var road_end = road.global_position.x + road_length
		if player_x - road_end > despawn_distance:
			despawn_road(road)

func spawn_road(position_x: float):
	var new_road = road_scene.instantiate()
	new_road.global_position = Vector3(position_x, 0, 0)
	add_child(new_road)
	roads.append(new_road)

func despawn_road(road: Node3D):
	road.queue_free()
	roads.erase(road)
