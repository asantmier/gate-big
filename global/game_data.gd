extends Node
## Holds static data about each round of the game

var ship_info : Dictionary
var ship_seed
var is_liar : bool

var shift := 1
var max_reprimands := 3
var reprimands := 0
var lied := 0
var processed := 0
var shift_rules := {
	1: {
		liars = 1,
		quota = 3
	}
}


func _ready():
	EventBus.ship_summoned.connect(_on_ship_summoned)
	EventBus.ship_left_gate.connect(_on_ship_left)
	EventBus.shift_started.connect(_on_shift_started)


func _on_ship_summoned():
	ship_seed = randi()
	is_liar = does_ship_lie()


func _on_ship_left():
	if is_liar:
		lied += 1
	processed += 1
	if processed < get_quota():
		EventBus.ship_summoned.emit()
	else:
		EventBus.quota_filled.emit()
		EventBus.shift_ended.emit()


func _on_shift_started():
	lied = 0
	processed = 0


## Deterministically decides if the current ship is a liar
func does_ship_lie() -> bool:
	var liars = shift_rules[shift].liars
	var quota = shift_rules[shift].quota
	var ships_remaining = quota - processed
	var liars_remaining = liars - lied
	if ships_remaining > liars_remaining:
		# 50% chance
		return ship_seed % 2 == 1
	else:
		return true


## Returns true if the ship should have been vaporized
func is_ship_bad() -> bool:
	return is_liar


## Produces random lies matching the ship info dictionary
func get_lies() -> Dictionary:
	return {
		Passengers = randi_range(1, 3) * rand_sign()
	}


func get_quota():
	return shift_rules[shift].quota


func get_liars_quota():
	return shift_rules[shift].liars


## Randomly returns 1 or -1
func rand_sign():
	if randi() % 2 == 1:
		return 1
	else:
		return -1
