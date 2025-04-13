extends Control

func _ready():
	DayAndNightCycleManager.time_tick.connect(update_arrow)

func update_arrow(day: int, hour: int, minute: int) -> void:
	# Ukryj wszystkie
	$ArrowTransition.visible = false
	$ArrowDay.visible = false
	$ArrowNight.visible = false

	# Aktywuj odpowiednią strzałkę
	if hour >= 6 and hour < 18:
		$ArrowDay.visible = true
	elif hour >= 20 or hour < 4:
		$ArrowNight.visible = true
	else:
		$ArrowTransition.visible = true
