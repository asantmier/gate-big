extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.shift_started.connect(play)
	EventBus.shift_ended.connect(stop)
