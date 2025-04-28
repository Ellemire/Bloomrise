extends CanvasLayer
@onready var game_menu_screen: CanvasLayer = $"."


func _on_start_game_button_pressed() -> void:
	GameManager.start_game()
	game_menu_screen.visible = false


func _on_save_game_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_game_button_pressed() -> void:
	GameManager.end_game()
