extends Label
## Counts down until the end of the shift


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.shift_started.connect(_on_shift_started)
	EventBus.shift_ended.connect(_on_shift_ended)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "%d:%02d" % [$Clock.time_left / 60, int($Clock.time_left) % 60]


func _on_shift_started():
	$Clock.start(5 * 60)


func _on_shift_ended():
	$Clock.stop()


func _on_clock_timeout():
	EventBus.time_up.emit()
