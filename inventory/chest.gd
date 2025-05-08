extends Node2D

@export var chest_data: Chest
@onready var chest_ui = $"../ChestUI"
@onready var chest_anim: AnimatedSprite2D = $ChestAnim
@onready var player: Player = $"../../Player"
@onready var chest_open_sound: AudioStreamPlayer2D = $ChestOpen
@onready var chest_colse_sound: AudioStreamPlayer2D = $ChestColse

var is_open = false

func _ready():
	$ClickArea.input_event.connect(_on_click)
	

func _on_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		toggle()

func _process(delta):
	if is_open:
		var distance = position.distance_to(player.position)
		if distance > 50:
			print("📦 Gracz odszedł – zamykam skrzynię (dystans:", distance, ")")
			toggle()  # użyj istniejącej funkcji zamykania

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
