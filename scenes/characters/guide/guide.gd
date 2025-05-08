extends Node2D

@onready var interactable_label_component: Control = $InteractableLabelComponent
@onready var interactable_component: InteractableComponent = $InteractableComponent
var tutorial_finished = false

var balloon_scene = preload("res://dialogues/game_dialogue_balloon.tscn")
var dialogue_resource: DialogueResource = preload("res://dialogues/conversations/guide.dialogue")
var in_range: bool = false

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()
	TaskManager.add_task("Go and talk to the owl", "tutorial", 1, 0)
	
func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range and event.is_action_pressed("show_dialogue"):
		var balloon = balloon_scene.instantiate() as BaseGameDialogueBalloon
		get_tree().root.add_child(balloon)

		match GameState.guide_checkpoint:
			"start":
				balloon.start(dialogue_resource, "start")
				TaskManager.report_progress("tutorial")
				TaskManager.add_task("Mine stones", "stone", 3, 5)
				TaskManager.add_task("Chop down trees", "log", 3, 5)
			"after_gathering":
				balloon.start(dialogue_resource, "pause")
			"after_inv":
				balloon.start(dialogue_resource, "after_inv_pause")
			"after_chest":
				balloon.start(dialogue_resource, "after_chest_pause")
				TaskManager.add_task("Till the ground", "tilling", 3, 3)
				TaskManager.add_task("Plant some roses", "plant_rose", 3, 8)
			"after_planting":
				balloon.start(dialogue_resource, "after_planting_pause")
				TaskManager.add_task("Water the roses", "watering", 3, 3)
				TaskManager.add_task("Collect the roses", "redrose", 3, 8)
			"after_watering":
				balloon.start(dialogue_resource, "after_watering_pause")
				TaskManager.add_task("Sell the roses", "sell_RedRose", 3, 8)
				TaskManager.add_task("Buy sunflower seeds", "buy_Sunflower", 1, 8)
				TaskManager.add_task("Earn 50 coins", "gold_earned", 50, 10)
			_:
				balloon.start(dialogue_resource, "start")
			
			
		
