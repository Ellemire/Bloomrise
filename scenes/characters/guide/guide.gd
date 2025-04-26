extends Node2D

@onready var interactable_label_component: Control = $InteractableLabelComponent
@onready var interactable_component: InteractableComponent = $InteractableComponent

var balloon_scene = preload("res://dialogues/game_dialogue_balloon.tscn")
var dialogue_resource: DialogueResource = preload("res://dialogues/conversations/guide.dialogue")
var in_range: bool = false

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()

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

		balloon.start(dialogue_resource, "start") # 🌟 Zawsze zaczynamy rozmowę od "start"
