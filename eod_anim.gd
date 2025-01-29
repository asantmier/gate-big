extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	play("RESET")
	EventBus.shift_ended.connect(_day_ended)


func _day_ended():
	play("end_day")
