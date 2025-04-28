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
var distance: float	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_player()
			remove_tilled_dirt_cell()
			
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_player()
			add_tilled_dirt_cell()

func get_cell_under_player() -> void:
	var player_local_position = grass_tilemap_layer.to_local(player.global_position)
	cell_position = grass_tilemap_layer.local_to_map(player_local_position)
	local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(grass_tilemap_layer.to_global(local_cell_position))

func add_tilled_dirt_cell() -> void:
	if distance < 20.0 && cell_source_id !=-1:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)

func remove_tilled_dirt_cell() -> void:
	if distance < 20.0:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)
