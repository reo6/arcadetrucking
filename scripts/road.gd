extends Node3D

@export var despawn_distance := 50.0  # Distance behind player to despawn
var player: Node3D

func _ready():
	# Find the player once when road spawns
	player = get_tree().get_first_node_in_group("player")
	
	# Set up despawn area
	var area = $DespawnArea
	area.body_exited.connect(_on_body_exited)
	area.position.z -= 10  # Adjust for scaled position

func _on_body_exited(body: Node):
	if body == player:
		if global_position.x < player.global_position.x - despawn_distance:
			queue_free()