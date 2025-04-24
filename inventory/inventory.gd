extends Resource

class_name Inv

signal update_slots

@export var slots: Array[InvSlot]

func insert(item: InvItem) -> bool:
	var itemslots = slots.filter(func(slot): return slot.item == item)

	if !itemslots.is_empty():
		itemslots[0].amount += 1
		update_slots.emit()
		return true
	
	var unique_filled_slots = slots.filter(func(slot): return slot.item != null)
	if unique_filled_slots.size() >= 12:
		print("❌ Inventory full – max 12 item types.")
		return false

	var emptyslots = slots.filter(func(slot): return slot.item == null)
	if !emptyslots.is_empty():
		emptyslots[0].item = item
		emptyslots[0].amount = 1
		update_slots.emit()
		return true

	return false
