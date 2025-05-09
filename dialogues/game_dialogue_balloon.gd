extends BaseGameDialogueBalloon

@onready var emotes_panel: Panel = $Balloon/Panel/Dialogue/HBoxContainer/EmotesPanel
@onready var ToolsPanel = get_tree().get_root().get_node("MainScene/GameScreen/ToolsPanel")
@onready var recived_sound: AudioStreamPlayer2D = $RecivedSound
@onready var owl_sound: AudioStreamPlayer2D = $OwlSound

func _ready():
	super._ready()
	randomize()

func get_random_emote() -> String:
	var emotes = ["emote_3_talk", "emote_2_advice"]
	return emotes[randi() % emotes.size()]

func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	super.start(dialogue_resource, title, extra_game_states)
	emotes_panel.play_emote(get_random_emote())
	owl_sound.play()

func next(next_id: String) -> void:
	super.next(next_id)
	owl_sound.play()
	emotes_panel.play_emote(get_random_emote())

func _on_mutated(mutation: Dictionary) -> void:
	super._on_mutated(mutation)
	print("💥 Mutation received:", mutation)
	recived_sound.play()
	
	if mutation.has("tool_pickaxe"):
		print("⛏️ Giving Pickaxe!")
		var item = InventoryManager.item_db["Pickaxe"]
		ToolsPanel.add_item_to_first_free_slot(item)

	elif mutation.has("tool_axe"):
		print("🪓 Giving Axe!")
		var item = InventoryManager.item_db["Axe"]
		ToolsPanel.add_item_to_first_free_slot(item)

	elif mutation.has("tool_tiller"):
		print("🪴 Giving Tiller!")
		var item = InventoryManager.item_db["Tiller"]
		ToolsPanel.add_item_to_first_free_slot(item)

	elif mutation.has("tool_watering_can"):
		print("🚿 Giving Watering Can!")
		var item = InventoryManager.item_db["WateringCan"]
		ToolsPanel.add_item_to_first_free_slot(item)
		
	elif mutation.has("rose_seeds"):
		print("🚿 Rose Seeds!")
		var item = InventoryManager.item_db["RedRoseSeeds"]
		ToolsPanel.add_item_to_first_free_slot(item)
	
	elif mutation.has("checkpoint_after_gathering"):
		GameState.guide_checkpoint = "after_gathering"
		queue_free()

	elif mutation.has("checkpoint_after_chest"):
		GameState.guide_checkpoint = "after_chest"
		queue_free()

	elif mutation.has("checkpoint_after_planting"):
		GameState.guide_checkpoint = "after_planting"
		queue_free()

	elif mutation.has("checkpoint_after_watering"):
		GameState.guide_checkpoint = "after_watering"
		queue_free()
	
	elif mutation.has("checkpoint_after_inv"):
		GameState.guide_checkpoint = "after_inv"
		queue_free()
	
	elif mutation.has("add_tasks"):
		print("📚 Skipping tutorial – dodajemy wszystkie zadania.")
		GameState.guide_checkpoint = "after_watering"

		TaskManager.add_task("Till the ground", "tilling", 3, 3)
		TaskManager.add_task("Plant some roses", "plant_rose", 3, 8)
		TaskManager.add_task("Water the roses", "watering", 3, 3)
		TaskManager.add_task("Collect the roses", "redrose", 3, 8)
		TaskManager.add_task("Sell the roses", "sell_RedRose", 3, 8)
		TaskManager.add_task("Buy sunflower seeds", "buy_Sunflower", 1, 8)
		TaskManager.add_task("Earn 50 coins", "gold_earned", 50, 10)
