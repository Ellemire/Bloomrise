extends Node

func spawn_drop(item: InvItem, pos: Vector2):
	if not InventoryManager.drop_scene_db.has(item.name):
		push_warning("❌ No drop scene for item: " + item.name)
		return

	var drop_scene = InventoryManager.drop_scene_db[item.name]
	var drop = drop_scene.instantiate()

	# Ustaw pozycję w świecie
	drop.global_position = pos

	# Jeśli obiekt ma CollectableComponent, to działa automatycznie
	get_tree().current_scene.add_child(drop)
