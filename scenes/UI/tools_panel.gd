extends PanelContainer

var tool_slots: Array = []

func _ready():
	call_deferred("_init_tool_slots")

func _init_tool_slots():
	var hbox = get_node_or_null("MarginContainer/HBoxContainer")
	if hbox:
		tool_slots = hbox.get_children()
		for slot in tool_slots:
			if slot.has_method("_pressed"):
				slot.connect("pressed", Callable(self, "_on_tool_slot_pressed").bind(slot))
			slot.add_to_group("tool_slot")
		print("✅ Gotowe! Sloty załadowane:", tool_slots.size())
		print("🎯 Loaded ToolsPanel instance:", self)

		_add_initial_tools()
	else:
		print("❌ Nadal nie widzę HBoxContainer.")

func _add_initial_tools():
	var starting_tools := ["Pickaxe", "Axe", "Tiller", "WateringCan"]
	for tool_name in starting_tools:
		if InventoryManager.item_db.has(tool_name):
			var item = InventoryManager.item_db[tool_name]
			add_item_to_first_free_slot(item)
		else:
			print("⚠️ Nie znaleziono w item_db:", tool_name)

func _on_tool_slot_pressed(slot):
	if not slot.is_empty():
		ToolManager.select_tool(slot.tool_data)

func add_item_to_first_free_slot(item):
	print("🔧 Próbuję dodać:", item.name)
	print("🧩 ToolsPanel instance:", self)
	print("🧩 Tool slots count:", tool_slots.size())
	for slot in tool_slots:
		print("iteruje")
		if slot.tool_data == DataTypes.Tools.None:
			slot.set_item(item)
			if slot.tool_data == DataTypes.Tools.None:
				print("⚠️ Przedmiot nie był narzędziem – pominięto")
				continue
			print("✅ Dodano:", item.name)
			return
	print("❌ Brak wolnych slotów lub brak narzędzi w przedmiocie")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("release_tool"):
		ToolManager.select_tool(DataTypes.Tools.None)
		for slot in tool_slots:
			slot.release_focus()
