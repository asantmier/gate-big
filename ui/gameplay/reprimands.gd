extends HBoxContainer


var life1 = true
var life2 = true
var life3 = true


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.ship_passed.connect(ship_evaluated.bind(false))
	EventBus.ship_killed.connect(ship_evaluated.bind(true))
	EventBus.reprimand_issued.connect(update_strikes)
	EventBus.reprimand_revoked.connect(update_strikes)
	EventBus.time_up.connect(_on_time_up)


func _on_time_up():
	GameData.issue_reprimand()


func ship_evaluated(killed):
	if (killed and not GameData.is_ship_bad()) or (not killed and GameData.is_ship_bad()):
		# Wait until the ship is gone to issue a reprimand
		# The locking also ensures that the ship doesn't change until after the reprimand is processed
		EventBus.lock_shift.emit()
		await EventBus.ship_left_gate
		GameData.issue_reprimand()
		EventBus.unlock_shift.emit()
	else:
		await EventBus.ship_left_gate
		EventBus.successful_passage.emit()
		$Success.play()


func update_strikes():
	var current = GameData.reprimands
	if life1:
		if current >= 1:
			$"Strike One/AnimationPlayer".play("die_out")
			life1 = false
	else:
		if current < 1:
			$"Strike One/AnimationPlayer".play("illuminate")
			life1 = true
	if life2:
		if current >= 2:
			$"Strike Two/AnimationPlayer".play("die_out")
			life2 = false
	else:
		if current < 2:
			$"Strike Two/AnimationPlayer".play("illuminate")
			life2 = true
	if life3:
		if current >= 3:
			$"Strike Three/AnimationPlayer".play("die_out")
			life3 = false
	else:
		if current < 3:
			$"Strike Three/AnimationPlayer".play("illuminate")
			life3 = true
