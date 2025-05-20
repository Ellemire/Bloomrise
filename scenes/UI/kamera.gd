extends Camera2D

@export var follow_speed: float = 5.0 

var target: Node2D

func _ready() -> void:
	target = get_parent() 
	make_current()

func _process(delta: float) -> void:	
	if not target:
		return

	# Smooth movement - lerpowanie pozycji
	global_position = lerp(global_position, target.global_position, follow_speed * delta)
	global_position = global_position.round()
