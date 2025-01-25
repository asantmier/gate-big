extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.ship_passed.connect(ship_evaluated.bind(false))
	EventBus.ship_killed.connect(ship_evaluated.bind(true))
	EventBus.reprimand_issued.connect(_on_reprimand_issued)


func ship_evaluated(killed):
	await EventBus.ship_left_gate
	# Wait until the ship is gone to issue a reprimand
	if (killed and not GameData.is_ship_bad()) or (not killed and GameData.is_ship_bad()):
		EventBus.reprimand_issued.emit()
	else:
		# :)
		pass


func add_strike():
	var animator : AnimationPlayer
	match GameData.reprimands:
		1: animator = $"Strike One/AnimationPlayer"
		2: animator = $"Strike Two/AnimationPlayer"
		3: animator = $"Strike Three/AnimationPlayer"
	#animator.play("illuminate")


func _on_reprimand_issued():
	GameData.reprimands += 1
	add_strike()
	if GameData.reprimands >= GameData.max_reprimands:
		EventBus.reprimand_limit_reached.emit()
