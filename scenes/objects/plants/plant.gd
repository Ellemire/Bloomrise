extends Node2D

@export var start_frame_offset: int = 0 # W której kolumnie zaczyna się dany kwiat (0 = róża, 1 = stokrotka itd.)
@export var frames_per_stage: int = 9 # Ile kwiatów w atlasie w poziomie

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent

var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
var harvest_scene: PackedScene
var flowers_preload: Dictionary = {
	0: preload("res://scenes/objects/flowersPlanting/red_rose.tscn"),
	1: preload("res://scenes/objects/flowersPlanting/orange_lily.tscn"),
	2: preload("res://scenes/objects/flowersPlanting/blue_daisy.tscn"),
	3: preload("res://scenes/objects/flowersPlanting/sunflower.tscn"),
	4: preload("res://scenes/objects/flowersPlanting/bluebell.tscn"),
	5: preload("res://scenes/objects/flowersPlanting/lavendar.tscn"),
	6: preload("res://scenes/objects/flowersPlanting/purple_orchid.tscn"),
	7: preload("res://scenes/objects/flowersPlanting/pink_tulip.tscn"),
	8: preload("res://scenes/objects/flowersPlanting/pink_peony.tscn"),
}

func _ready() -> void:
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	if flowers_preload.has(start_frame_offset):
		harvest_scene = flowers_preload[start_frame_offset]
	else:
		harvest_scene = flowers_preload[0]
	
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)

func _process(delta: float) -> void:
	var growth_state = growth_cycle_component.get_current_growth_state()
	update_sprite_for_state(growth_state)
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true
		
func update_sprite_for_state(state: int) -> void:
	sprite_2d.frame = frames_per_stage * state + start_frame_offset

func on_hurt(hit_damage: int) -> void:
	print("Plant is watered!")
	if !growth_cycle_component.is_watered:
		emit_watering_particles()
		growth_cycle_component.is_watered = true

func on_crop_maturity() -> void:
	flowering_particles.emitting = true

func on_crop_harvesting() -> void:
	var harvest_instance = harvest_scene.instantiate() as Node2D
	harvest_instance.global_position = global_position
	get_parent().add_child(harvest_instance)
	
	queue_free()
		
func emit_watering_particles() -> void:
	watering_particles.emitting = true
	await get_tree().create_timer(2.0).timeout
	watering_particles.emitting = false
