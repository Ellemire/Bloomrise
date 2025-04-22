extends Node

enum Weather { SUNNY, CLOUDY, RAINY }

var current_weather: Weather = Weather.SUNNY
var rng := RandomNumberGenerator.new()

signal weather_changed(new_weather: Weather)

func _ready():
	rng.randomize()
	
	DayAndNightCycleManager.time_tick_day.connect(_on_new_day)
	_on_new_day(0)

func _on_new_day(day: int) -> void:
	var roll = rng.randf()
	if roll < 0.3:
		current_weather = Weather.SUNNY
	elif roll < 0.7:
		current_weather = Weather.RAINY
	else:
		current_weather = Weather.CLOUDY
		
	weather_changed.emit(current_weather)
	
func get_current_weather() -> int:
	return current_weather
