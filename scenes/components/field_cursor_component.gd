class_name FieldCursorComponent
extends Node2D

@export var grass_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 1

@onready var player: Player = get_tree().get_first_node_in_group("player")

var cell_position: Vector2i
var local_cell_position: Vector2
var cell_source_id: int
var collision_shape: CollisionShape2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("unhit"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_tiller()
			remove_tilled_dirt_cell()
			
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_tiller()
			add_tilled_dirt_cell()

func get_cell_under_tiller() -> void:
	var player_direction = player.get_player_direction()
	var player_global_position = player.global_position
	var tiller_global_position = get_tiller_hit_position(player_global_position, player_direction)
	var tiller_local_position = grass_tilemap_layer.to_local(tiller_global_position)
	cell_position = grass_tilemap_layer.local_to_map(tiller_local_position)
	local_cell_position = grass_tilemap_layer.map_to_local(cell_position)

func add_tilled_dirt_cell() -> void:
	if cell_source_id !=-1:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)

func remove_tilled_dirt_cell() -> void:
	tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)
		
func get_tiller_hit_position(player_position: Vector2, player_direction: Vector2) -> Vector2:
	var offset := Vector2.ZERO
	print(player_direction)
	
	match player_direction:
		Vector2.UP:
			offset = Vector2(0, -18)
		Vector2.RIGHT:
			offset = Vector2(9, 0)
		Vector2.LEFT:
			offset = Vector2(-9, 0)
		_:
			offset = Vector2(0, 3)
	
	return player_position + offset + Vector2(12, 12)
