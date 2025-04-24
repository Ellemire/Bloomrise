extends Panel

@onready var item_icon: TextureRect = $CenterContainer/Item_icon
@onready var amount_label: Label = $AmountLabel

var slot_data: InvSlot

func update(slot: InvSlot):
	slot_data = slot
	if !slot.item:
		item_icon.visible = false
		amount_label.visible = false
	else:
		item_icon.visible = true
		item_icon.texture = slot.item.texture
		if slot.amount > 1:
			amount_label.visible = true
		amount_label.text = str(slot.amount)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if Input.is_key_pressed(KEY_SHIFT) and slot_data and slot_data.item:
			print("🗑 Wyrzucanie przedmiotu:", slot_data.item.name)

			# Zamiast pozycji myszy — używamy pozycji gracza!
			if InventoryManager.player:
				var drop_position = InventoryManager.player.global_position + Vector2(20, 0)
				ItemDropManager.spawn_drop(slot_data.item, drop_position)
			else:
				print("⚠️ InventoryManager.player is null")

			slot_data.amount -= 1
			if slot_data.amount <= 0:
				slot_data.item = null

			InventoryManager.inventory.update_slots.emit()
