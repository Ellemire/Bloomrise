extends Label
@onready var coin_label: Label = $"."

func _ready():
	GameManager.gold_changed.connect(update_gold)
	update_gold()

func update_gold(new_value: int = GameManager.player_gold):
	coin_label.text = "%d" % new_value
