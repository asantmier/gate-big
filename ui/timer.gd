extends Label
## Counts down until the end of the shift


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.start_shift.connect(_on_start_shift)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "%d:%d" % [$Clock.time_left / 60, int($Clock.time_left) % 60]


func _on_start_shift():
	$Clock.start(5 * 60)


func _on_clock_timeout():
	EventBus.time_up.emit()
