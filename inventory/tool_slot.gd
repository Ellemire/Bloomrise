extends Button

var tool_name_to_type := {
	"None": DataTypes.Tools.None,
	"Axe": DataTypes.Tools.AxeWood,
	"Tiller": DataTypes.Tools.TillGround,
	"WateringCan": DataTypes.Tools.WaterCrops,
	"Pickaxe": DataTypes.Tools.MineStone,
	"Log": DataTypes.Tools.Log,
	"Stone": DataTypes.Tools.Stone,
	"BluebellSeeds": DataTypes.Tools.BluebellSeeds,
	"BlueDaisySeeds": DataTypes.Tools.BlueDaisySeeds,
	"LavendarSeeds": DataTypes.Tools.LavendarSeeds,
	"OrangeLilySeeds": DataTypes.Tools.OrangeLilySeeds,
	"PinkPeonySeeds": DataTypes.Tools.PinkPeonySeeds,
	"PinkTulipSeeds": DataTypes.Tools.PinkTulipSeeds,
	"PurpleOrchidSeeds": DataTypes.Tools.PurpleOrchidSeeds,
	"RedRoseSeeds": DataTypes.Tools.RedRoseSeeds,
	"SunflowerSeeds": DataTypes.Tools.SunflowerSeeds
}

@onready var tool_icon: TextureRect = $CenterContainer/Tool_icon

var tool_data: DataTypes.Tools = DataTypes.Tools.None
var item_ref: Object = null

func is_empty() -> bool:
	return tool_data == DataTypes.Tools.None

func set_item(item):
	print("🧪 Próba dodania item:", item.name)
	print("🧪 Dostępne klucze tool_name_to_type:", tool_name_to_type.keys())

	if tool_name_to_type.has(item.name):
		print("✅ Rozpoznano jako narzędzie:", item.name)
		tool_data = tool_name_to_type[item.name]
		item_ref = item
		tool_icon.texture = item.texture
		tool_icon.visible = true

	else:
		print("❌ Przedmiot", item.name, "nie jest narzędziem – nie zostanie dodany")

func clear_slot():
	tool_data = DataTypes.Tools.None
	item_ref = null
	tool_icon.texture = null
	tool_icon.visible = false

func _on_pressed() -> void:
	if not is_empty():
		ToolManager.select_tool(tool_data)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if not is_empty():
				print("🔄 Próbuję odłożyć:", item_ref.name)
				var success = InventoryManager.inventory.insert(item_ref)
				if success:
					print("✅ Odłożono do inventory:", item_ref.name)
					clear_slot()
					ToolManager.select_tool(DataTypes.Tools.None)  # odznacz narzędzie jeśli aktywne
				else:
					print("❌ Brak miejsca w inventory – nie odłożono")
