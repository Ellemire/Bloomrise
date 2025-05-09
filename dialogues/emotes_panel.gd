extends Panel

@onready var animated_sprite_2d: AnimatedSprite2D = $Emote/AnimatedSprite2D
@onready var emote_idle_timer: Timer = $EmoteIdleTimer

var idle_emotes: Array = ["emote_1_idle", "emote_2_advice", "emote_3_talk"]

func _ready() -> void:
	animated_sprite_2d.play("emote_1_idle")

func play_emote(animation: String) -> void:
	animated_sprite_2d.play(animation)

func _on_emote_idle_timer_timeout() -> void:
	var index = randi_range(0,0)
	var emote = idle_emotes[index] 
	
	animated_sprite_2d.play(emote)

	
