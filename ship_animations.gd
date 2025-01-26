extends AnimationPlayer
## Animates the ship's movement and signals when its ready for the next ship


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_finished.connect(_on_animation_finished)
	EventBus.ship_summoned.connect(ship_summoned)
	EventBus.ship_passed.connect(_on_ship_passed)
	EventBus.ship_killed.connect(_on_ship_killed)


func ship_summoned():
	EventBus.ship_unfocused.emit()
	play("float_in")


func _on_ship_passed():
	EventBus.ship_unfocused.emit()
	play("float_out")


func _on_ship_killed():
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
