extends HBoxContainer


var last


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.ship_passed.connect(ship_evaluated.bind(false))
	EventBus.ship_killed.connect(ship_evaluated.bind(true))
	EventBus.reprimand_issued.connect(_on_reprimand_issued)
	last = 0


func ship_evaluated(killed):
	await EventBus.ship_left_gate
	# Wait until the ship is gone to issue a reprimand
	if (killed and not GameData.is_ship_bad()) or (not killed and GameData.is_ship_bad()):
		GameData.issue_reprimand()
	else:
		# :)
		pass


func update_strikes():
	var current = GameData.reprimands
	if current == 0:
		if last >= 3:
			$"Strike Three/AnimationPlayer".play("illuminate")
		if last >= 2:
			$"Strike Two/AnimationPlayer".play("illuminate")
		if last >= 1:
			$"Strike One/AnimationPlayer".play("illuminate")
	if current >= 1: # At least 1 reprimand
		if last < 1: # Did not already have 1 reprimand
			$"Strike One/AnimationPlayer".play("die_out")
	if current >= 2:
		if last < 2:
			$"Strike Two/AnimationPlayer".play("die_out")
	if current >= 3:
		if last < 3:
			$"Strike Three/AnimationPlayer".play("die_out")
	last = current


func _on_reprimand_issued():
	update_strikes()
