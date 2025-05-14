extends Node

var main_scene_path: String = "res://scenes/level/level_scene.tscn"
var main_scene: PackedScene
var main_scene_instance: Node

var player_gold: int = 0
signal gold_changed(new_value: int)

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

func add_gold(amount: int, report_progress: bool = true):
	player_gold += amount
	gold_changed.emit(player_gold)

	if report_progress:
		TaskManager.report_progress("gold_earned", amount)

	
func subtract_gold(amount: int) -> bool:
	if player_gold >= amount:
		player_gold -= amount
		gold_changed.emit(player_gold)
		return true
	return false

func get_gold() -> int:
	return player_gold
