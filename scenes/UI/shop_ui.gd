extends CanvasLayer

@onready var item_grid: GridContainer = $MarginContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/ItemGrid
@onready var gold_label: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/GoldLabel
@onready var close_button: Button = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/CloseButton

var player_gold: int = 20

var flowers_texture = preload("res://assetss/Terrain/Plants/flowers.png")
var ShopItemScene = preload("res://scenes/UI/ShopItem.tscn")

func _ready():
	visible = false
	_create_items()
	close_button.pressed.connect(close)

func _create_items():
	var item_data = [
		{"id": "seed_1", "name": "RedRose", "price": 5, "icon_index": 0},
		{"id": "seed_2", "name": "OrangeLily", "price": 6, "icon_index": 1},
		{"id": "seed_3", "name": "BlueDaisy", "price": 7, "icon_index": 2},
		{"id": "seed_4", "name": "Sunflower", "price": 4, "icon_index": 3},
		{"id": "seed_5", "name": "Bluebell", "price": 6, "icon_index": 4},
		{"id": "seed_6", "name": "Lavendar", "price": 5, "icon_index": 5},
		{"id": "seed_7", "name": "PurpleOrchid", "price": 8, "icon_index": 6},
		{"id": "seed_8", "name": "PinkTulip", "price": 9, "icon_index": 7},
		{"id": "seed_9", "name": "PinkPeony", "price": 10, "icon_index": 8},
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
	if player_gold >= item.price:
		player_gold -= item.price
		update_gold()
		InventoryManager.add_collectable(item.name + "Seeds")
		print("Bought:", item.name)
	else:
		print("Not enough gold!")

func update_gold():
	gold_label.text = "Gold: %d" % player_gold

func open():
	visible = true
	update_gold()

func close():
	visible = false
