extends PanelContainer

@onready var tools_panel: PanelContainer = $"."
@onready var tool_pickaxe: Button = $MarginContainer/HBoxContainer/ToolPickaxe
@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
@onready var tool_watering: Button = $MarginContainer/HBoxContainer/ToolWatering



func _on_tool_pickaxe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.MineStone)


func _on_tool_axe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.AxeWood)


func _on_tool_watering_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.WaterCrops)


func _on_tool_tilling_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.TillGround)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("release_tool"):
		ToolManager.select_tool(DataTypes.Tools.None)
		tool_pickaxe.release_focus()
		tool_axe.release_focus()
		tool_tilling.release_focus()
		tool_watering.release_focus()
