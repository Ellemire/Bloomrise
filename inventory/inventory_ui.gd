extends Control

@onready var inv: Inv = preload("res://inventory/playerinv.tres")
@onready var slots: Array = $PanelContainer/MarginContainer/GridContainer.get_children()
@onready var ToolsPanel: PanelContainer = $"../ToolsPanel"
	
var is_open = false

func _ready():
	inv.update_slots.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
		
		# Podłącz sygnał jeśli nie jest jeszcze podłączony
		if not slots[i].is_connected("item_sent_to_toolbar", Callable(self, "_on_item_sent_to_toolbar")):
			slots[i].connect("item_sent_to_toolbar", Callable(self, "_on_item_sent_to_toolbar"))


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory_open"):
		if is_open:
			close()
		else:
			open()

func _on_item_sent_to_toolbar(item_slot: InvSlot):
	print("📥 Otrzymano item_sent_to_toolbar:", item_slot.item.name)
	var success = ToolsPanel.add_item_to_first_free_slot(item_slot.item)
	if success:
		print("🗑 Usuwam z inventory:", item_slot.item.name)
		item_slot.amount -= 1
		if item_slot.amount <= 0:
			item_slot.item = null
		inv.update_slots.emit()
	else:
		print("⚠️ Nie udało się dodać do toolbar – przedmiot zostaje w inventory")


func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
