extends AnimationPlayer
## Animates the ship's movement and signals when its ready for the next ship


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_finished.connect(_on_animation_finished)
	EventBus.start_shift.connect(summon_ship)
	EventBus.summon_ship.connect(summon_ship)
	EventBus.pass_ship.connect(_on_pass_ship)
	EventBus.kill_ship.connect(_on_kill_ship)


func summon_ship():
	EventBus.ship_unfocused.emit()
	play("float_in")


func _on_pass_ship():
	EventBus.ship_unfocused.emit()
	play("float_out")


func _on_kill_ship():
	EventBus.ship_unfocused.emit()
	play("explode")


func _on_animation_finished(anim_name):
	match anim_name:
		"float_in":
			EventBus.ship_focused.emit()
		"float_out":
			EventBus.ship_left_gate.emit()
		"explode":
			EventBus.ship_left_gate.emit()
