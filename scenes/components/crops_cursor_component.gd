class_name CropsCursosComponent
extends Node

@export var dirt_tilemap_layer: TileMapLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")

# var rose_plant_scene = preload()
# var sunflower_plant_scene = preload()

var mouse_position: Vector2
var cell_position: Vector2i
var local_cell_position: Vector2
var cell_source_id: int
var distance: float

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()
			
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.PlantRose or ToolManager.selected_tool == DataTypes.Tools.PlantSunflower:
			get_cell_under_mouse()
			add_crop()
			
func get_cell_under_mouse() -> void:
	mouse_position = dirt_tilemap_layer.get_local_mouse_position()
	cell_position = dirt_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = dirt_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = dirt_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)

func add_crop() -> void:
	pass
	#if distance < 20.0:
		#if ToolManager.selected_tool == DataTypes.Tools.PlantRose:
			#var rose_instance = rose_plant_scene.instantiate() as Node2D
			#rose_instance.global_position = local_cell_position
			#get_parent().find_child("Cropfields").add_child(rose_instance)
			#
		#if ToolManager.selected_tool == DataTypes.Tools.PlantSunflower:
			#var sunflower_instance = sunflower_plant_scene.instantiate() as Node2D
			#sunflower_instance.global_position = local_cell_position
			#get_parent().find_child("Cropfields").add_child(sunflower_instance)

func remove_crop() -> void:
	if distance < 20.0:
		var crop_nodes = get_parent().find_child("Cropfields").get_children()
		
		for node: Node2D in crop_nodes:
			if node.global_position == local_cell_position:
				node.queue_free()
