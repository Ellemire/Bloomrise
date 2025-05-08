extends Node

@onready var inventory: Inv = preload("res://inventory/playerinv.tres")

var item_db: Dictionary = {
	"Sunflower": preload("res://inventory/items/sunflower.tres"),
	"SunflowerSeeds": preload("res://inventory/items/sunflower_seeds.tres"),
	"Bluebell": preload("res://inventory/items/bluebell.tres"),
	"BluebellSeeds": preload("res://inventory/items/bluebell_seeds.tres"),
	"BlueDaisy": preload("res://inventory/items/blue_daisy.tres"),
	"BlueDaisySeeds": preload("res://inventory/items/blue_daisy_seeds.tres"),
	"Lavendar": preload("res://inventory/items/lavendar.tres"),
	"LavendarSeeds": preload("res://inventory/items/lavendar_seeds.tres"),
	"OrangeLily": preload("res://inventory/items/orange_lily.tres"),
	"OrangeLilySeeds": preload("res://inventory/items/orange_lily_seeds.tres"),
	"PinkPeony": preload("res://inventory/items/pink_peony.tres"),
	"PinkPeonySeeds": preload("res://inventory/items/pink_peony_seeds.tres"),
	"PinkTulip": preload("res://inventory/items/pink_tulip.tres"),
	"PinkTulipSeeds": preload("res://inventory/items/pink_tulip_seeds.tres"),
	"PurpleOrchid": preload("res://inventory/items/purple_orchid.tres"),
	"PurpleOrchidSeeds": preload("res://inventory/items/purple_orchid_seeds.tres"),
	"RedRose": preload("res://inventory/items/red_rose.tres"),
	"RedRoseSeeds": preload("res://inventory/items/red_rose_seeds.tres"),
	"Log": preload("res://inventory/items/wood.tres"),
	"Stone": preload("res://inventory/items/stone.tres"),
	"Axe": preload("res://inventory/items/axe.tres"),
	"Pickaxe": preload("res://inventory/items/pickaxe.tres"),
	"Tiller": preload("res://inventory/items/tiller.tres"),
	"WateringCan": preload("res://inventory/items/watering_can.tres")
}

var drop_scene_db := {
	# Flowers Planting
	"Bluebell": preload("res://scenes/objects/flowersPlanting/bluebell.tscn"),
	"BlueDaisy": preload("res://scenes/objects/flowersPlanting/blue_daisy.tscn"),
	"Lavendar": preload("res://scenes/objects/flowersPlanting/lavendar.tscn"),
	"OrangeLily": preload("res://scenes/objects/flowersPlanting/orange_lily.tscn"),
	"PinkPeony": preload("res://scenes/objects/flowersPlanting/pink_peony.tscn"),
	"PinkTulip": preload("res://scenes/objects/flowersPlanting/pink_tulip.tscn"),
	"PurpleOrchid": preload("res://scenes/objects/flowersPlanting/purple_orchid.tscn"),
	"RedRose": preload("res://scenes/objects/flowersPlanting/red_rose.tscn"),
	"Sunflower": preload("res://scenes/objects/flowersPlanting/sunflower.tscn"),

	# Flowers Seeds
	"BluebellSeeds": preload("res://scenes/objects/flowersSeeds/bluebell_seeds.tscn"),
	"BlueDaisySeeds": preload("res://scenes/objects/flowersSeeds/blue_daisy_seeds.tscn"),
	"LavendarSeeds": preload("res://scenes/objects/flowersSeeds/lavendar_seeds.tscn"),
	"OrangeLilySeeds": preload("res://scenes/objects/flowersSeeds/orange_lily_seeds.tscn"),
	"PinkPeonySeeds": preload("res://scenes/objects/flowersSeeds/pink_peony_seeds.tscn"),
	"PinkTulipSeeds": preload("res://scenes/objects/flowersSeeds/pink_tulip_seeds.tscn"),
	"PurpleOrchidSeeds": preload("res://scenes/objects/flowersSeeds/purple_orchid_seeds.tscn"),
	"RedRoseSeeds": preload("res://scenes/objects/flowersSeeds/red_rose_seeds.tscn"),
	"SunflowerSeeds": preload("res://scenes/objects/flowersSeeds/sunflower_seeds.tscn"),
	
	"Log": preload("res://scenes/objects/trees/log.tscn"),
	"Stone": preload("res://scenes/objects/stones/stone.tscn"),
	"Axe": preload("res://scenes/objects/tools/axe.tscn"),
	"Pickaxe": preload("res://scenes/objects/tools/pickaxe.tscn"),
	"Tiller": preload("res://scenes/objects/tools/tiller.tscn"),
	"WateringCan": preload("res://scenes/objects/tools/watering_can.tscn")
}


var player: Player

func add_collectable(name: String) -> bool:
	if item_db.has(name):
		var item = item_db[name]
		var added = inventory.insert(item)
		if added:
			print("✔ Added to inventory:", name)
			TaskManager.report_progress(name)
			return true
		else:
			print("❌ Inventory full – could not add:", name)
			return false
	else:
		push_warning("❌ Item not found in database: " + name)
		return false
		
func remove_item(item: InvItem, amount: int) -> bool:
	return inventory.remove(item, amount)
