extends Node2D

@export var chest_data: Chest
@onready var chest_ui = $"../ChestUI"
@onready var chest_anim: AnimatedSprite2D = $ChestAnim
@onready var player: Player = $"../../Player"
@onready var chest_open_sound: AudioStreamPlayer2D = $ChestOpen
@onready var chest_colse_sound: AudioStreamPlayer2D = $ChestColse
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

var is_open = false
var in_range: bool = false

func _ready():
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()

func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false

func _process(delta):
	if is_open:
		var distance = position.distance_to(player.position)
		if distance > 50:
			print("📦 Gracz odszedł – zamykam skrzynię (dystans:", distance, ")")
			toggle()

	# Sprawdzanie wciśnięcia przycisku tylko gdy gracz jest blisko
	if in_range and Input.is_action_just_pressed("show_dialogue"):
		toggle()

func toggle():
	var distance = position.distance_to(player.position)
	if not is_open and distance > 50:
		print("⛔ Za daleko, aby otworzyć skrzynię! (dystans:", distance, ")")
		return
	if is_open:
		chest_anim.play("chest_close")
		chest_colse_sound.play()
		is_open = false
		chest_ui.close()
	else:
		chest_anim.play("chest_open")
		chest_open_sound.play()
		is_open = true
		print("📦 Skrzynia otwarta!")
		chest_ui.open_for(chest_data)
