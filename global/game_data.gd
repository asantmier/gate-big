extends Node
## Holds static data about each round of the game

var ship_info : Dictionary
var is_liar : bool
var is_smuggler : bool

var shift := 1
var max_reprimands := 3
var reprimands := 0
var lied := 0
var smuggled := 0
var processed := 0
var shift_rules := {
	1: {
		liars = 1, # Liars lie on their manifest
		quota = 3,
		criminals = [GameConstants.RED_FACTION],
		contraband = [GameConstants.GRIN, GameConstants.OMINOUS_MOO_DENG],
		smugglers = 1, # Smugglers carry contraband or criminals
		criminal_rate = 0.4, # % of passengers that will be criminals on a smuggler
	}
}


func _ready():
	EventBus.ship_summoned.connect(_on_ship_summoned)
	EventBus.ship_left_gate.connect(_on_ship_left)
	EventBus.shift_started.connect(_on_shift_started)


func _on_ship_summoned():
	pass
	#ship_seed = randi()
	#is_liar = does_ship_lie()


func prep_next_ship():
	# This needs to be called before the summon signal is emitted so that the ship
	# can reference this information when it runs code on summon
	is_liar = _does_ship_lie()
	is_smuggler = _does_ship_smuggle()


func _on_ship_left():
	if is_liar:
		lied += 1
	processed += 1
	if processed < get_quota():
		prep_next_ship()
		EventBus.ship_summoned.emit()
	else:
		EventBus.quota_filled.emit()
		EventBus.shift_ended.emit()


func _on_shift_started():
	lied = 0
	processed = 0
	prep_next_ship()


## Decides if the current ship is a liar
func _does_ship_lie() -> bool:
	var liars = shift_rules[shift].liars
	var quota = shift_rules[shift].quota
	var ships_remaining = quota - processed
	var liars_remaining = liars - lied
	if ships_remaining > liars_remaining:
		# 50% chance
		return randi() % 2 == 1
	else:
		return true


## Decides if the current ship is a smuggler
func _does_ship_smuggle() -> bool:
	var smugglers = shift_rules[shift].smugglers
	var quota = shift_rules[shift].quota
	var ships_remaining = quota - processed
	var smugglers_remaining = smugglers - smuggled
	if ships_remaining > smugglers_remaining:
		# 50% chance
		return randi() % 2 == 1
	else:
		return true


## Returns true if the ship should have been vaporized
func is_ship_bad() -> bool:
	return is_liar or is_smuggler


## Produces random lies matching the ship info dictionary
func get_lies() -> Dictionary:
	return {
		Passengers = randi_range(1, 3) * rand_sign()
	}


func get_quota():
	return shift_rules[shift].quota


func get_liars_quota():
	return shift_rules[shift].liars


func get_smugglers_quota():
	return shift_rules[shift].smugglers


## Returns criminals array
func get_illegal_factions() -> Array:
	return shift_rules[shift].criminals


## Returns opposite of criminals array
func get_legal_factions() -> Array:
	var illegal_factions = get_illegal_factions()
	var legal_factions = GameConstants.get_all_factions_list()
	for f in illegal_factions:
		legal_factions.erase(f)
	return legal_factions


## Returns contraband array
func get_illegal_cargo() -> Array:
	return shift_rules[shift].contraband


## Returns opposite of contraband array
func get_legal_cargo() -> Array:
	var illegal_cargo = get_illegal_cargo()
	var legal_cargo = GameConstants.get_all_cargo_list()
	for c in illegal_cargo:
		legal_cargo.erase(c)
	return legal_cargo


func get_criminal_rate():
	return shift_rules[shift].criminal_rate


## Randomly returns 1 or -1
func rand_sign():
	if randi() % 2 == 1:
		return 1
	else:
		return -1


func issue_reprimand():
	reprimands += 1
	EventBus.reprimand_issued.emit()
	if GameData.reprimands >= GameData.max_reprimands:
		EventBus.reprimand_limit_reached.emit()
