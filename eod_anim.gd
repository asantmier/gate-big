extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	play("RESET")
	queue("hide_eod")
	EventBus.shift_started.connect(_on_shift_started)
	EventBus.shift_ended.connect(_day_ended)
	EventBus.game_won.connect(_on_game_won)


func _day_ended():
	play("end_day")


func _on_game_won():
	play("game_over_fade")


func _on_shift_started():
	play("RESET")
	queue("hide_eod")
