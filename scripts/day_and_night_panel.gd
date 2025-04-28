extends Control
@onready var time_label: Label = $TimeLabel
@onready var day_label: Label = $DayLabel
@onready var weather_img := $Weather_img

const WEATHER = preload("res://assetss/UI/WeatherIcons/Weather.png")


@export var normal_speed: int = 5
@export var fast_speed: int = 200

func _ready() -> void:
	DayAndNightCycleManager.time_tick.connect(on_time_tick)
	WeatherManager.weather_changed.connect(update_icon)
	update_icon(WeatherManager.current_weather)

func on_time_tick(day: int, hour: int, minute: int) -> void:
	day_label.text = "Day " + str(day)
	time_label.text = "%02d:%02d" % [hour, minute]
	

func _on_normal_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = normal_speed


func _on_fast_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = fast_speed

func update_icon(weather):
	var atlas := AtlasTexture.new()
	atlas.atlas = WEATHER
	atlas.region = Rect2(Vector2(weather * 32, 0), Vector2(32, 32))
	weather_img.texture = atlas
