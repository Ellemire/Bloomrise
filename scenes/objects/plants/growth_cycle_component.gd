class_name GrowthCycleComponent
extends Node

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(5, 365) var days_until_harvest: int = 8

signal crop_maturity
signal crop_harvesting
signal growth_state_changed(new_state: int)

var starting_day: int = 0
var watered_on_day: int = -1
var num_states = 4  # Germination, Sprouting, Flowering, Maturity
var days_per_state = int(days_until_harvest / num_states)
var grow_day = 0

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)
	WeatherManager.weather_changed.connect(on_weather_changed)
	if WeatherManager.current_weather == WeatherManager.Weather.RAINY:
		is_watered_today()
		

func on_time_tick_day(day: int) -> void:
	print("Today: ", day, " Watered: ", watered_on_day)
	if can_grow(day):
		growth_states(starting_day, day)

func growth_states(starting_day: int, current_day: int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Maturity or current_growth_state == DataTypes.GrowthStates.Harvesting:
		harvest_state(starting_day, current_day)
		return

	#var total_days = current_day - starting_day
	var new_state = clamp(current_growth_state + 1, 0, DataTypes.GrowthStates.Maturity)
	print("Current: ", current_growth_state, " Watered ", watered_on_day, " New: ", new_state)
	
	if current_growth_state != new_state:
		grow_day = current_day
		current_growth_state = new_state
		growth_state_changed.emit(current_growth_state)

		if current_growth_state == DataTypes.GrowthStates.Maturity:
			crop_maturity.emit()

func harvest_state(starting_day: int, current_day: int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return

	var days_passed = current_day - starting_day
	if days_passed >= days_until_harvest:
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()

func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state

func on_weather_changed(new_weather: int) -> void:
	if new_weather == WeatherManager.Weather.RAINY:
		is_watered_today()

func is_watered_today():
	watered_on_day = DayAndNightCycleManager.current_day

func was_watered_on_day(day: int) -> bool:
	return watered_on_day == day

func can_grow(current_day: int) -> bool:
	var can_grow_day = grow_day + days_per_state
	if current_day >= can_grow_day:
		if watered_on_day >= grow_day:
			return true
	return false
