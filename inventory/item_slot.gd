extends Panel

@onready var item_icon: TextureRect = $CenterContainer/Item_icon
@onready var amount_label: Label = $AmountLabel


func update(slot: InvSlot):
	if !slot.item:
		item_icon.visible = false
		amount_label.visible = false
	else:
		item_icon.visible = true
		item_icon.texture = slot.item.texture
		if slot.amount > 1:
			amount_label.visible = true
		amount_label.text = str(slot.amount)
