extends Node

var main_scene_path: String = "res://scenes/level/level_scene.tscn"
@onready var collect_sound := preload("res://assetss/Sounds/collect-points-190037.mp3")

func play_collect_sound():
	var sound = AudioStreamPlayer.new()
	sound.stream = collect_sound
	add_child(sound)
	sound.play()
	sound.finished.connect(sound.queue_free)
