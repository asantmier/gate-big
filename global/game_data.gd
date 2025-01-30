extends Node
## Holds static data about each round of the game

var ship_info : Dictionary
var is_liar : bool
var is_smuggler : bool
var is_fatty: bool

var allowed_smuggler : bool
var allowed_fatty : bool

var shift := 1
var max_reprimands := 3
var reprimands := 0

var lied := 0
var smuggled := 0
var fattied := 0
var processed := 0

var shift_locked := 0

var shift_rules := {
	0: {
		quota = 0,
		time = 5 * 60,
		liars = 0, # Liars lie on their manifest
		smugglers = 0, # Smugglers carry contraband or criminals
		fatties = 0, # Fatties carry over the limit of passengers or cargo
		criminals = [],
		contraband = [],
		criminal_rate = 0.4, # % of passengers that will be criminals on a smuggler
		cargo_limit = 50,
		passenger_limit = 50,
		incarceration_rate = 0.6, # % of ships that will be bad
	},
	1: {
		quota = 1,
		time = 10 * 60,
		liars = 1, # Liars lie on their manifest
		smugglers = 0, # Smugglers carry contraband or criminals
		fatties = 0, # Fatties carry over the limit of passengers or cargo
		criminals = [],
		contraband = [],
		criminal_rate = 0.4, # % of passengers that will be criminals on a smuggler
		cargo_limit = 20,
		passenger_limit = 50,
		incarceration_rate = 0.6, # % of ships that will be bad
	},
	2: {
		quota = 4,
		time = 5 * 60,
		liars = 1, # Liars lie on their manifest
		smugglers = 0, # Smugglers carry contraband or criminals
		fatties = 2, # Fatties carry over the limit of passengers or cargo
		call_methods = ["enable_smuggler"],
		criminals = [],
		contraband = [],
		criminal_rate = 0.4, # % of passengers that will be criminals on a smuggler
		cargo_limit = 12,
		passenger_limit = 8,
		incarceration_rate = 0.6, # % of ships that will be bad
	},
	3: {
		quota = 4,
		time = 5 * 60,
		liars = 0, # Liars lie on their manifest
		smugglers = 2, # Smugglers carry contraband or criminals
		call_methods = ["enable_fatty"],
		fatties = 0, # Fatties carry over the limit of passengers or cargo
		criminals = [GameConstants.BLUE_CY_FACTION, GameConstants.BLUE_MG_FACTION, GameConstants.BLUE_YL_FACTION],
		contraband = [GameConstants.GRIN, GameConstants.OMINOUS_MOO_DENG],
		criminal_rate = 0.4, # % of passengers that will be criminals on a smuggler
		cargo_limit = 16,
		passenger_limit = 12,
		incarceration_rate = 0.6, # % of ships that will be bad
	},
	4: {
		quota = 5,
		time = 5 * 60,
		liars = 0, # Liars lie on their manifest
		smugglers = 2, # Smugglers carry contraband or criminals
		fatties = 1, # Fatties carry over the limit of passengers or cargo
		criminals = [GameConstants.BLUE_CY_FACTION, GameConstants.BLUE_MG_FACTION, GameConstants.BLUE_YL_FACTION],
		contraband = [GameConstants.GRIN, GameConstants.OMINOUS_MOO_DENG],
		criminal_rate = 0.4, # % of passengers that will be criminals on a smuggler
		cargo_limit = 16,
		passenger_limit = 12,
		incarceration_rate = 0.6, # % of ships that will be bad
	},
	5: {
		quota = 7,
		time = 5 * 60,
		liars = 1, # Liars lie on their manifest
		smugglers = 1, # Smugglers carry contraband or criminals
		fatties = 1, # Fatties carry over the limit of passengers or cargo
		criminals = [GameConstants.BLUE_CY_FACTION, GameConstants.BLUE_MG_FACTION, GameConstants.BLUE_YL_FACTION],
		contraband = [GameConstants.GRIN, GameConstants.OMINOUS_MOO_DENG],
		criminal_rate = 0.4, # % of passengers that will be criminals on a smuggler
		cargo_limit = 20,
		passenger_limit = 16,
		incarceration_rate = 0.6, # % of ships that will be bad
	}
}
var final_shift := 5


func _ready():
	EventBus.ship_left_gate.connect(_on_ship_left)
	EventBus.shift_started.connect(_on_shift_started)
	EventBus.game_begun.connect(set.bind("shift", 0))
	EventBus.lock_shift.connect(add_lock)
	EventBus.unlock_shift.connect(remove_lock)
	allowed_smuggler = false
	allowed_fatty = false


func add_lock():
	shift_locked += 1

func remove_lock():
	shift_locked -= 1


func enable_smuggler():
	print("enabled smuggling")
	allowed_smuggler = true


func enable_fatty():
	print("enabled fatties")
	allowed_fatty = true


func prep_next_ship():
	# This needs to be called before the summon signal is emitted so that the ship
	# can reference this information when it runs code on summon
	# TODO BETTER PROCESS
	# Determine x baddies and y goodies
	# Add forced liars/smugglers/fatties and random traits to array
	# Add remaining required baddies to array
	# Add goodies to array
	# Randomly sort array
	# Simply pop ships off the array to check their traits
	
	is_liar = false
	is_smuggler = false
	is_fatty = false
	
	var is_criminal = _does_ship_break_law()
	print("Making new ship. Criminal status: %s" % is_criminal)
	if is_criminal:
		add_crime_trait()
		# 40% chance to add an additional trait
		if randf() < 0.6:
			add_crime_trait()
			# 40% chance to add an additional trait
			if randf() < 0.6:
				add_crime_trait()


func _on_ship_left():
	if is_liar:
		lied += 1
	if is_smuggler:
		smuggled += 1
	if is_fatty:
		fattied += 1
	processed += 1
	if processed < get_quota():
		prep_next_ship()
		EventBus.ship_summoned.emit()
	else:
		EventBus.quota_filled.emit()
		end_shift()


func _on_shift_started():
	shift += 1
	lied = 0
	smuggled = 0
	fattied = 0
	processed = 0
	
	for strname in shift_rules[shift].get("call_methods", []):
		call(strname)
	
	prep_next_ship()


## Decides if the current ship is a lawbreaker
func _does_ship_break_law():
	# Must be a criminal if: Sum of remaining criminal types >= remaining ships
	var needed_liars = max(shift_rules[shift].liars - lied, 0)
	var needed_smugglers = max(shift_rules[shift].smugglers - smuggled, 0)
	var needed_fatties = max(shift_rules[shift].fatties - fattied, 0)
	
	var bad_guy = false
	if _needs_force_trait():
		# Ship should be bad if we need more bad guys than we have ships left
		bad_guy = true
	
	# Otherwise chance to be bad based on shift settings
	var frank = randf()
	if frank < shift_rules[shift].incarceration_rate:
		bad_guy = true
	
	return bad_guy


func _needs_force_trait():
	var needed_liars = max(shift_rules[shift].liars - lied, 0)
	var needed_smugglers = max(shift_rules[shift].smugglers - smuggled, 0)
	var needed_fatties = max(shift_rules[shift].fatties - fattied, 0)
	
	return needed_fatties + needed_liars + needed_smugglers >= get_ships_remaining()


## Adds a criminal type to the ship
func add_crime_trait():
	# Force add a necessary trait if this is the first trait added and one is needed
	if not (is_liar or is_smuggler or is_fatty) and _needs_force_trait():
		var needed_liars = max(shift_rules[shift].liars - lied, 0)
		var needed_smugglers = max(shift_rules[shift].smugglers - smuggled, 0)
		var needed_fatties = max(shift_rules[shift].fatties - fattied, 0)
		# Forces a necessary trait to be added
		if needed_liars > 0:
			is_liar = true
			print("Forced liar")
		elif needed_smugglers > 0:
			is_smuggler = true
			print("Forced smuggler")
		elif needed_fatties > 0:
			is_fatty = true
			print("Forced fatty")
		return

	# Otherwise picks a random remaining trait
	var arr = ["liar", "smuggler", "fatty"]
	if is_liar:
		arr.erase("liar")
	if is_smuggler or not allowed_smuggler:
		arr.erase("smuggler")
	if is_fatty or not allowed_fatty:
		arr.erase("fatty")
	if arr.is_empty(): return
	var rand = arr.pick_random()
	match rand:
		"liar":
			is_liar = true
			print("Added liar")
		"smuggler":
			is_smuggler = true
			print("Added smuggler")
		"fatty":
			is_fatty = true
			print("Added fatty")
	#arr.erase(rand)


## Returns true if the ship should have been vaporized
func is_ship_bad() -> bool:
	return is_liar or is_smuggler or is_fatty


func get_ships_remaining() -> int:
	return shift_rules[shift].quota - processed


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


func get_fatties_quota():
	return shift_rules[shift].fatties


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


## Returns percentage of passengers that must be criminals on smugglers
func get_criminal_rate():
	return shift_rules[shift].criminal_rate


## Returns maximum legal cargo quantity
func get_cargo_limit():
	return shift_rules[shift].cargo_limit


## Returns maximum legal passenger quantity
func get_passenger_limit():
	return shift_rules[shift].passenger_limit


## Returns timer length
func get_shift_time():
	return shift_rules[shift].time


func is_final_shift() -> bool:
	return shift == final_shift


## Randomly returns 1 or -1
func rand_sign():
	if randi() % 2 == 1:
		return 1
	else:
		return -1


## Ends the shift, respecting locks
func end_shift():
	if GameData.reprimands >= GameData.max_reprimands: return # Don't go to next shift if game overed
	
	if shift_locked > 0:
		var callback = func():
			if GameData.reprimands >= GameData.max_reprimands: return # Don't go to next shift if game overed
			EventBus.shift_ended.emit()
		EventBus.unlock_shift.connect(callback, CONNECT_ONE_SHOT)
	else:
		EventBus.shift_ended.emit()


## Issues a reprimand, handling life count and game overs
func issue_reprimand():
	reprimands += 1
	EventBus.reprimand_issued.emit()
	if GameData.reprimands >= GameData.max_reprimands:
		EventBus.reprimand_limit_reached.emit()


## Revokes a reprimand
func revoke_reprimand():
	if reprimands > 0:
		reprimands -= 1
		EventBus.reprimand_revoked.emit()
