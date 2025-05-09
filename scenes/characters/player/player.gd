class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@onready var tool_selected_sound: AudioStreamPlayer2D = $ToolSelectedSound
@onready var collected_sound: AudioStreamPlayer2D = $CollectedSound

var player_direction: Vector2

func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)
	InventoryManager.player = self
	
func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool
	tool_selected_sound.play()
	print("tool ", tool)

func get_player_direction() -> Vector2:
	return player_direction

func _on_collectable_collected(name: String) -> void:
	collected_sound.play()
