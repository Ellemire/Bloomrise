class_name GrowthCycleComponent
extends Node

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(5, 365) var days_until_harvest: int = 7

signal crop_maturity
signal crop_harvesting

var is_watered: bool
var starting_day: int
var current_day: int

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)
	WeatherManager.weather_changed.connect(on_weather_changed)
	
func on_time_tick_day(day: int) -> void:
	if is_watered:
		if starting_day == 0:
			starting_day = day
			
		growth_states(starting_day, day)
		harvest_state(starting_day, day)
		
			
func growth_states(starting_day: int, current_day: int):
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return
		
	var num_states = 5
	
	var growth_days_passed = (current_day - starting_day) % num_states
	var states_index = growth_days_passed % num_states
	
	current_growth_state = states_index
	
	var name = DataTypes.GrowthStates.keys()[current_growth_state]
	
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()
		
	is_watered = false
	
func harvest_state(starting_day: int, current_day: int):
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return
		
	var days_passed = (current_day - starting_day) % days_until_harvest
	
	if days_passed == days_until_harvest - 1:
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()
	
func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state

func on_weather_changed(new_weather: int) -> void:
	if new_weather == WeatherManager.Weather.RAINY:
		is_watered = true
