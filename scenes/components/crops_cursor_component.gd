class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var crop_fileds: Node2D = $"../CropFileds"

var plant_scene = preload("res://scenes/objects/plants/plant.tscn")

var cell_position: Vector2i
var local_cell_position: Vector2
var cell_source_id: int
var distance: float

var tool_to_flower_offset: Dictionary = {
	DataTypes.Tools.RedRoseSeeds: 0,
	DataTypes.Tools.OrangeLilySeeds: 1,
	DataTypes.Tools.BlueDaisySeeds: 2,
	DataTypes.Tools.SunflowerSeeds: 3,
	DataTypes.Tools.BluebellSeeds: 4,
	DataTypes.Tools.LavendarSeeds: 5,
	DataTypes.Tools.PurpleOrchidSeeds: 6,
	DataTypes.Tools.PinkTulipSeeds: 7,
	DataTypes.Tools.PinkPeonySeeds: 8,
}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_player()
			remove_crop()
			
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool in tool_to_flower_offset.keys():
			get_cell_under_player()
			add_crop()

func get_cell_under_player() -> void:
	var player_local_position = tilled_soil_tilemap_layer.to_local(player.global_position)
	cell_position = tilled_soil_tilemap_layer.local_to_map(player_local_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(tilled_soil_tilemap_layer.to_global(local_cell_position))

func add_crop() -> void:
	if distance < 20.0:
		if is_cell_empty(local_cell_position):
			var plant_instance = plant_scene.instantiate() as Node2D

			var offset = tool_to_flower_offset.get(ToolManager.selected_tool, 0)
			plant_instance.set("start_frame_offset", offset)
			
			plant_instance.global_position = tilled_soil_tilemap_layer.to_global(local_cell_position)
			crop_fileds.add_child(plant_instance)

func remove_crop() -> void:
	if distance < 20.0:
		var crop_nodes = crop_fileds.get_children()
		
		for node: Node2D in crop_nodes:
			if node.global_position.distance_to(tilled_soil_tilemap_layer.to_global(local_cell_position)) < 5.0:
				node.queue_free()
				break

func is_cell_empty(position: Vector2) -> bool:
	for node in crop_fileds.get_children():
		if node.global_position.distance_to(tilled_soil_tilemap_layer.to_global(position)) < 5.0:
			return false
	return true
