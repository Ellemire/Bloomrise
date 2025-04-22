extends CanvasLayer

@onready var cloud_overlay = $CloudOverlay
@onready var rain_particles = $RainParticles
@onready var rain_sound = $RainSound

func _ready():
	WeatherManager.weather_changed.connect(apply_weather)
	apply_weather(WeatherManager.current_weather)

func apply_weather(weather):
	match weather:
		WeatherManager.Weather.SUNNY:
			cloud_overlay.visible = false
			rain_particles.emitting = false
			rain_sound.stop()
		WeatherManager.Weather.CLOUDY:
			cloud_overlay.visible = true
			rain_particles.emitting = false
			rain_sound.stop()
		WeatherManager.Weather.RAINY:
			cloud_overlay.visible = true
			rain_particles.emitting = true
			rain_sound.play()
