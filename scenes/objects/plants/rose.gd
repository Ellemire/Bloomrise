extends Node2D

var rose_harvest_scane = preload("res://scenes/objects/flowersPlanting/red_rose.tscn")

@export var start_frame_offset: int = 5 # W której kolumnie zaczyna się dany kwiat (0 = róża, 1 = stokrotka itd.)
@export var frames_per_stage: int = 9 # Ile kwiatów w atlasie w poziomie
@export var is_large_at_end: bool = true # Czy ostatnie 2 stany zajmują 2 kratki

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent

var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed

var growth_state_to_frame_index := {
	DataTypes.GrowthStates.Seed: 0,
	DataTypes.GrowthStates.Germination: 2,
	DataTypes.GrowthStates.Vegetative: 3,
	DataTypes.GrowthStates.Reproduction: 4,
	DataTypes.GrowthStates.Maturity: 5,
	DataTypes.GrowthStates.Harvesting: 1,
}

func _ready() -> void:
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)

func _process(delta: float) -> void:
	var growth_state = growth_cycle_component.get_current_growth_state()
	update_sprite_for_state(growth_state)
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true
		
func update_sprite_for_state(state: int) -> void:
	var frame_index = growth_state_to_frame_index.get(state, 0)
	sprite_2d.frame = frames_per_stage * frame_index + start_frame_offset
	
	# Jeśli to stan 4 (maturity), to pokazuje większy sprite
	if is_large_at_end and (state == DataTypes.GrowthStates.Maturity or state == DataTypes.GrowthStates.Reproduction):
		sprite_2d.scale.x = 2
	else:
		sprite_2d.scale.x = 1

func on_hurt() -> void:
	if !growth_cycle_component.is_watered:
		watering_particles.emitting = true
		await get_tree().create_timer(5.0).timeout
		watering_particles.emitting = false
		growth_cycle_component.is_watered = true

func on_crop_maturity() -> void:
	flowering_particles.emitting = true

func on_crop_harvesting() -> void:
	var rose_harvest_instance = rose_harvest_scane.instantiate() as Node2D
	rose_harvest_instance.global_position = global_position
	get_parent().add_child(rose_harvest_instance)
	
	queue_free()
