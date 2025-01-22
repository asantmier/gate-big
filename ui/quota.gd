extends Label
## Summons additional ships until the quota is met

var quota : int = 5
var processed : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.pass_ship.connect(_on_pass_ship)
	EventBus.ship_left_gate.connect(_on_ship_processed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "%d/%d" % [processed, quota]


func _on_pass_ship():
	processed += 1


func _on_ship_processed():
	if processed < quota:
		EventBus.summon_ship.emit()
	else:
		EventBus.quota_filled.emit()
