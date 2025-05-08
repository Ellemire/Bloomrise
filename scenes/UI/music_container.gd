extends HBoxContainer
@onready var sound_button: Button = $SoundButton
@onready var game_music: AudioStreamPlayer2D = $GameMusic

const music_icon_texture: Texture2D = preload("res://scenes/UI/nutki.png")
var is_music_playing := true

func _on_ready() -> void:
	game_music.play()

func _on_sound_button_pressed() -> void:
	if is_music_playing:
		game_music.stop()
	else:
		game_music.play()

	is_music_playing = !is_music_playing
	_update_icon()

func _update_icon() -> void:
	var atlas = AtlasTexture.new()
	atlas.atlas = music_icon_texture
	if is_music_playing:
		atlas.region = Rect2(Vector2(22, 0), Vector2(22, 22))
	else:
		atlas.region = Rect2(Vector2(0, 0), Vector2(22, 22))
	sound_button.icon = atlas
