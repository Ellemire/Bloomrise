extends Node

var main_scene_path: String = "res://scenes/level/level_scene.tscn"
var main_scene: PackedScene
var main_scene_instance: Node

func start_game() -> void:
	print("Starting game...")
	
	if main_scene_instance:
		main_scene_instance.queue_free()
	
	if not main_scene:
		main_scene = load(main_scene_path)
	
	main_scene_instance = main_scene.instantiate()
	
	get_tree().root.add_child(main_scene_instance)
	
	get_tree().current_scene = main_scene_instance

func end_game() -> void:
	print("Ending game...")
	
	if main_scene_instance:
		main_scene_instance.queue_free()
		main_scene_instance = null
		
	get_tree().quit()
