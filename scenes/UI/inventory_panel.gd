extends PanelContainer

@onready var log_label: Label = $MarginContainer/VBoxContainer/Logs/LogLabel
@onready var stone_label: Label = $MarginContainer/VBoxContainer/Stone/StoneLabel
@onready var red_rose_label: Label = $MarginContainer/VBoxContainer/RedRose/RedRoseLabel
@onready var orange_lily_label: Label = $MarginContainer/VBoxContainer/OrangeLily/OrangeLilyLabel

func _ready() -> void:
	InventoryManager.inventory_changed.connect(on_inventory_changed)

func on_inventory_changed() -> void:
	var inventory: Dictionary = InventoryManager.inventory
	
	if inventory.has("log"):
		log_label.text = str(inventory["log"])
	
	if inventory.has("stone"):
		stone_label.text = str(inventory["stone"])
	
	if inventory.has("RedRose"):
		red_rose_label.text = str(inventory["RedRose"])
	
	if inventory.has("OrangeLily"):
		orange_lily_label.text = str(inventory["OrangeLily"])
