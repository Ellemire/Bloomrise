extends Control
@onready var task_list_label: RichTextLabel = $Panel/TaskListLabel

var updating := false

func _ready():
	TaskManager.tasks_updated.connect(update_task_list, CONNECT_DEFERRED)
	update_task_list()

func update_task_list():
	if updating:
		print("🔄 Skipping update (already updating)")
		return
	print("🔃 Updating task list")
	updating = true

	if not is_instance_valid(TaskManager):
		task_list_label.text = "Currently you have no active tasks."
		updating = false
		return

	var lines := TaskManager.get_task_descriptions()

	if lines.is_empty():
		task_list_label.text = "Currently you have no active tasks."
	else:
		task_list_label.text = "Tasks:\n" + "\n".join(lines)

	updating = false
