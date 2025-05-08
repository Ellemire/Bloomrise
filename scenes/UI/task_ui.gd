extends Control
@onready var task_list_label: RichTextLabel = $Panel/TaskListLabel

func _ready():
	TaskManager.tasks_updated.connect(update_task_list)
	update_task_list()

func update_task_list():
	var lines = TaskManager.get_task_descriptions()

	if lines.is_empty():
		task_list_label.text = "Currently you have no active tasks."
	else:
		task_list_label.text = "Tasks:\n" + "\n".join(lines)
