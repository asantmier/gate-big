extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.ship_passed.connect(_on_ship_passed)
	EventBus.ship_killed.connect(fire_gun)


func _on_ship_passed():
	var bad = GameData.is_ship_bad()
	await EventBus.ship_left_gate
	if bad:
		# play animation
		pass
	else:
		# play animation
		pass


func fire_gun():
	# play animation
	pass
