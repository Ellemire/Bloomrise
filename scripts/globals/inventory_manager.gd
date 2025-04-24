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
	"Stone": preload("res://inventory/items/stone.tres")
}


func add_collectable(name: String) -> bool:
	if item_db.has(name):
		var item = item_db[name]
		var added = inventory.insert(item)
		if added:
			print("✔ Added to inventory:", name)
			return true
		else:
			print("❌ Inventory full – could not add:", name)
			return false
	else:
		push_warning("❌ Item not found in database: " + name)
		return false
