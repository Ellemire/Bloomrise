class_name CollectableComponent
extends Area2D

@export var collectable_name: String
@onready var collecting_sound: AudioStreamPlayer2D = $CollectingSound

func _on_body_entered(body: Node2D) -> void:
	collecting_sound.play()
	if body is Player:
		var was_collected = InventoryManager.add_collectable(collectable_name)
		if was_collected:
			collecting_sound.play()
			print("Collected: ", collectable_name)
			get_parent().queue_free()
		else:
			print("Could not collect:", collectable_name)
