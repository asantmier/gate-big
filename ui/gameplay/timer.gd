extends Label
## Counts down until the end of the shift

var monitoring := false

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.shift_started.connect(_on_shift_started)
	EventBus.shift_ended.connect(_on_shift_ended)
	EventBus.reprimand_limit_reached.connect(_on_reprimand_limit_reached)
	EventBus.cheat_time.connect($Clock.start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "%d:%02d" % [$Clock.time_left / 60, int($Clock.time_left) % 60]
	
	if $Clock.time_left <= 10.0 and monitoring:
		if not $RunningOut.playing:
			$RunningOut.play()


func _on_shift_started():
	$Clock.start(GameData.get_shift_time())
	monitoring = true


func _on_shift_ended():
	monitoring = false
	stop_clock()


func _on_reprimand_limit_reached():
	monitoring = false
	stop_clock()


func stop_clock():
	$Clock.stop()
	$RunningOut.stop()


func _on_clock_timeout():
	$RunningOut.stop()
	EventBus.time_up.emit()
	GameData.end_shift()
	print("yikes!")
