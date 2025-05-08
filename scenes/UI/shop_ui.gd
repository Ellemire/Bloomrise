extends CanvasLayer

@onready var item_grid: GridContainer = $MarginContainer/Panel/MarginContainer/VBoxContainer/TabContainer/BuyTab/BuyScroll/BuyGrid
@onready var gold_label: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/GoldLabel
@onready var close_button: Button = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/CloseButton
@onready var sell_grid: GridContainer = $MarginContainer/Panel/MarginContainer/VBoxContainer/TabContainer/SellTab/SellScroll/SellGrid
@onready var tab_container: TabContainer = $MarginContainer/Panel/MarginContainer/VBoxContainer/TabContainer

var player_gold: int = 100

var flowers_texture = preload("res://assetss/Terrain/Plants/flowers.png")
var ShopItemScene = preload("res://scenes/UI/ShopItem.tscn")
var name_dictionary = {
	"Red Rose": "RedRoseSeeds",
	"Orange Lily": "OrangeLilySeeds",
	"Blue Daisy": "BlueDaisySeeds", 
	"Sunflower": "SunflowerSeeds",
	"Bluebell": "BluebellSeeds",
	"Lavendar": "LavendarSeeds",
	"Orchid": "PurpleOrchidSeeds",
	"Pink Tulip": "PinkTulipSeeds",
	"Pink Peony": "PinkPeonySeeds"
}


func _ready():
	visible = false
	_create_buy_items()
	close_button.pressed.connect(close)

func open():
	visible = true
	update_gold()

func close():
	visible = false
	
func update_gold():
	gold_label.text = "Gold: %d" % GameManager.get_gold()

func _on_tab_container_tab_changed(tab: int) -> void:
	var tab_name = tab_container.get_tab_title(tab)
	
	if tab_name == "SellTab":
		populate_sell_items()
	if tab_name == "BuyTab":
		pass

func get_base_name(name: String) -> String:
	return name_dictionary.get(name, name)

func format_name(raw_name: String) -> String:
	var formatted := ""
	for i in raw_name.length():
		var char := raw_name[i]
		if i > 0 and char == char.to_upper() and char != char.to_lower():
			formatted += " "
		formatted += char
	return formatted


# ----------------------
# BUY SECTION
# ----------------------

func _create_buy_items():
	var item_data = [
		{"id": "seed_1", "name": "Red Rose", "price": 5, "icon_index": 0},
		{"id": "seed_2", "name": "Orange Lily", "price": 6, "icon_index": 1},
		{"id": "seed_3", "name": "Blue Daisy", "price": 7, "icon_index": 2},
		{"id": "seed_4", "name": "Sunflower", "price": 4, "icon_index": 3},
		{"id": "seed_5", "name": "Bluebell", "price": 6, "icon_index": 4},
		{"id": "seed_6", "name": "Lavendar", "price": 5, "icon_index": 5},
		{"id": "seed_7", "name": "Orchid", "price": 8, "icon_index": 6},
		{"id": "seed_8", "name": "Pink Tulip", "price": 9, "icon_index": 7},
		{"id": "seed_9", "name": "Pink Peony", "price": 10, "icon_index": 8},
	]

	for item in item_data:
		var item_instance = ShopItemScene.instantiate()

		var icon = item_instance.get_node("MarginContainer/Panel/MarginContainer/Icon")
		var name_label = item_instance.get_node("MarginContainer/Panel/MarginContainer/NameLabel")
		var price_label = item_instance.get_node("MarginContainer/Panel/MarginContainer/HBoxContainer/PrizeLabel")
		var buy_button = item_instance.get_node("MarginContainer/BuyButton")

		icon.texture = get_icon(item.icon_index)
		name_label.text = item.name
		price_label.text = str(item.price)

		buy_button.pressed.connect(func(): _buy_item(item))

		item_grid.add_child(item_instance)

func get_icon(index: int) -> AtlasTexture:
	var tex = AtlasTexture.new()
	tex.atlas = flowers_texture
	var tile_size = Vector2(16, 16)
	var region_position = Vector2(index % 9, index / 9) * tile_size
	tex.region = Rect2(region_position, tile_size)
	return tex

func _buy_item(item):
	if GameManager.player_gold >= item.price:
		GameManager.subtract_gold(item.price)
		update_gold()
		InventoryManager.add_collectable(get_base_name(item.name))
		print("Bought:", item.name)
	else:
		print("Not enough gold!")


# ----------------------
# SELL SECTION
# ----------------------

func populate_sell_items():
	for child in sell_grid.get_children():
		child.queue_free()
	
	for slot in InventoryManager.inventory.slots:
		if slot.item != null and slot.amount > 0 and slot.item.sell_price > 0:
			_add_sell_item(slot)

func _add_sell_item(slot):
	var item_instance = ShopItemScene.instantiate()

	# Referencje do UI
	var icon = item_instance.get_node("MarginContainer/Panel/MarginContainer/Icon")
	var name_label = item_instance.get_node("MarginContainer/Panel/MarginContainer/NameLabel")
	var price_label = item_instance.get_node("MarginContainer/Panel/MarginContainer/HBoxContainer/PrizeLabel")
	var sell_button = item_instance.get_node("MarginContainer/SellButton")
	var buy_button = item_instance.get_node("MarginContainer/BuyButton")
	var minus_button = item_instance.get_node("MarginContainer/HBoxContainer/MinusButton")
	var plus_button = item_instance.get_node("MarginContainer/HBoxContainer/PlusButton")
	var number_label = item_instance.get_node("MarginContainer/HBoxContainer/Number")
	var quantity_container = item_instance.get_node("MarginContainer/HBoxContainer")

	# Ustawienie UI
	buy_button.visible = false
	sell_button.visible = true
	quantity_container.visible = true
	
	icon.texture = slot.item.texture
	name_label.text = format_name(slot.item.name)
	price_label.text = str(slot.item.sell_price)

	var count := int(slot.amount)
	number_label.text = str(count)

	minus_button.pressed.connect(func():
		if count > 1:
			count -= 1
			number_label.text = str(count)
	)

	plus_button.pressed.connect(func():
		if count < slot.amount:
			count += 1
			number_label.text = str(count)
	)

	sell_button.pressed.connect(func():
		var current_count := int(number_label.text)
		
		if count > slot.amount:
			print("❌ Not enough items!")
			return

		var price = slot.item.sell_price
		var item_name = slot.item.name

		if InventoryManager.remove_item(slot.item, count):
			GameManager.add_gold(price * current_count)
			update_gold()
			populate_sell_items()
			print("✅ Sold:", item_name)
	)

	sell_grid.add_child(item_instance)
