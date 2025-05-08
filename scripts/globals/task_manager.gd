extends Node

signal tasks_updated

var task_queue: Array[Dictionary] = []
var current_task: Dictionary = {}

var task_complete_sound: AudioStreamPlayer = AudioStreamPlayer.new()
var task_sound_stream := preload("res://assetss/Sounds/collect-points-190037.mp3")

func _ready():
	add_child(task_complete_sound)
	task_complete_sound.stream = task_sound_stream

func add_task(name: String, id: String, target: int, award: int = 10) -> void:
	task_queue.append({
		"name": name,
		"id": id.to_lower(),
		"progress": 0,
		"target": target,
		"award": award
	})
	if current_task.is_empty():
		_next_task()

func add_tasks(list: Array[Dictionary]) -> void:
	for task in list:
		add_task(task["name"], task["id"], task["target"], task.get("award", 10))

func _next_task() -> void:
	if task_queue.size() > 0:
		current_task = task_queue.pop_front()
		print("📝 New task started:", current_task["name"])
	else:
		current_task = {}
		print("✅ All tasks completed.")
	emit_signal("tasks_updated")

func report_progress(resource_id: String, amount: int = 1) -> void:
	if current_task.is_empty():
		return

	var normalized_id = resource_id.to_lower()

	if current_task["id"] == normalized_id:
		current_task["progress"] += amount
		current_task["progress"] = min(current_task["progress"], current_task["target"])
		print("📈 Progress:", current_task["progress"], "/", current_task["target"])
		emit_signal("tasks_updated")

		if current_task["progress"] >= current_task["target"]:
			_on_task_completed()

func _on_task_completed() -> void:
	print("🎉 Task completed:", current_task["name"])

	var award = current_task.get("award", 10)

	GameManager.add_gold(award)
	print("💰 %d coins awarded!" % award)

	task_complete_sound.play()

	current_task = {}
	_next_task()

func get_task_descriptions() -> Array[String]:
	if current_task.is_empty():
		return []

	var name = current_task["name"]
	var progress = current_task["progress"]
	var target = current_task["target"]
	var award = current_task.get("award", 0)

	var line = "%s %d/%d" % [name, progress, target]
	if award > 0:
		line += " (Reward: %d 🪙)" % award

	return [line]
