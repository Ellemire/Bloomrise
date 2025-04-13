extends Node2D

@onready var shop_ui = $"../ShopUI"

func _ready():
	$ClickArea.input_event.connect(_on_click)

func _on_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shop_ui.open()
