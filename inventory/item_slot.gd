extends Panel

@onready var item_icon: TextureRect = $CenterContainer/Item_icon
@onready var amount_label: Label = $AmountLabel

signal item_sent_to_toolbar(item)

var slot_data: InvSlot
var parent_chest: Chest = null

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
	if event is InputEventMouseButton and event.pressed and slot_data and slot_data.item:

		# 🖱️ PRAWY PRZYCISK – wyrzucanie
		if event.button_index == MOUSE_BUTTON_RIGHT:
			print("🗑 Wyrzucanie przedmiotu:", slot_data.item.name)
			if InventoryManager.player:
				var drop_position = InventoryManager.player.global_position + Vector2(20, 0)
				ItemDropManager.spawn_drop(slot_data.item, drop_position)
			else:
				print("⚠️ InventoryManager.player is null")
			slot_data.amount -= 1
			if slot_data.amount <= 0:
				slot_data.item = null
			if parent_chest:
				parent_chest.update_slots.emit()
			else:
				InventoryManager.inventory.update_slots.emit()

		# 👈 LEWY PRZYCISK – przenoszenie do toolbaru LUB shift-click
		elif event.button_index == MOUSE_BUTTON_LEFT:
			# 🔁 SHIFT + LPM – przenoszenie między inventory a skrzynią
			if Input.is_key_pressed(KEY_SHIFT):
				if parent_chest != null:
					# Ze skrzyni DO inventory
					print("↪️ Przenoszę ze skrzyni do inventory:", slot_data.item.name)
					var success = InventoryManager.inventory.insert(slot_data.item)
					if success:
						slot_data.amount -= 1
						if slot_data.amount <= 0:
							slot_data.item = null
						parent_chest.update_slots.emit()
					else:
						print("❌ Inventory pełne – nie przeniesiono")
				else:
					# Z inventory DO skrzyni
					print("📦 Przenoszę z inventory do skrzyni:", slot_data.item.name)
					# Wybierz najbliższą otwartą skrzynię – uproszczone
					var chest_ui = get_tree().get_root().get_node("MainScene/Chest/ChestUI")  # ← DOPASUJ ŚCIEŻKĘ
					if chest_ui and chest_ui.chest:
						var success = chest_ui.chest.insert(slot_data.item)
						if success:
							slot_data.amount -= 1
							if slot_data.amount <= 0:
								slot_data.item = null
							InventoryManager.inventory.update_slots.emit()
						else:
							print("❌ Skrzynia pełna – nie przeniesiono")
					else:
						print("⚠️ Nie znaleziono otwartej skrzyni")
			else:
				# LPM bez SHIFT → do toolbaru
				print("📢 Emituję sygnał item_sent_to_toolbar:", slot_data.item.name)
				emit_signal("item_sent_to_toolbar", slot_data)
				InventoryManager.inventory.update_slots.emit()
