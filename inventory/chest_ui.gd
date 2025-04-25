extends CanvasLayer

var chest: Chest
@onready var slots: Array = $PanelContainer/VBoxContainer/MarginContainer/GridContainer.get_children()

func _ready():
	visible = false

func open_for(chest_ref: Chest):
	chest = chest_ref
	if not chest.update_slots.is_connected(update_slots):
		chest.update_slots.connect(update_slots)
	update_slots()
	visible = true

func close():
	visible = false
	if chest and chest.update_slots.is_connected(update_slots):
		chest.update_slots.disconnect(update_slots)

func update_slots():
	for i in range(min(chest.slots.size(), slots.size())):
		slots[i].update(chest.slots[i])
		slots[i].parent_chest = chest
