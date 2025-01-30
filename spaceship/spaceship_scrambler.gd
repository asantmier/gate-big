extends Node2D

@export var floors : Array[Floor]
@export var cargo_bays : Array[Cargo]

var passengers : int
var cargo : int
var factions : Array
var cargo_types : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.ship_summoned.connect(scramble_ship)
	#print(GameConstants.normalize_array([.5, .8, .3]))
	#scramble_ship()


func submit_manifest():
	var info_dict : Dictionary
	info_dict.Passengers = passengers
	info_dict.Cargo = cargo
	info_dict.Factions = factions
	info_dict.CargoTypes = cargo_types
	
	GameData.ship_info = info_dict


func scramble_ship():
	var smuggle_people = false
	var smuggle_cargo = false
	if GameData.is_smuggler:
		var random = randf()
		if random < 0.3:
			smuggle_people = true
		elif random < 0.6:
			smuggle_cargo = true
		else:
			smuggle_people = true
			smuggle_cargo = true
			
	randomize_passengers(smuggle_people)
	randomize_cargo(smuggle_cargo)
	submit_manifest()


## Randomizes the amount and type of cargo in each bay
func randomize_cargo(smuggle = false):
	cargo = 0
	
	var limit = GameData.get_cargo_limit()
	var p_request = randi_range(limit / 2, limit)
	if GameData.is_fatty:
		p_request = randi_range(limit + 1, (limit + 1) * 1.2)
	
	# Constructs an array that represents the cargo to be in each bay
	var c_count_arr = []
	c_count_arr.resize(cargo_bays.size())
	c_count_arr = c_count_arr.map(func(num): return 0)
	var accepting_bays = range(cargo_bays.size())
	var sum = 0
	while sum < p_request and not accepting_bays.is_empty():
		var bay = accepting_bays.pick_random()
		c_count_arr[bay] += 1
		if c_count_arr[bay] == cargo_bays[bay].get_max():
			accepting_bays.erase(bay)
		
		sum = c_count_arr.reduce(func(accum, num): return accum + num)
	
	print("Filled ship with cargo: %s" % [c_count_arr])
	
	for bay in cargo_bays:
		bay.quantity = c_count_arr.pop_front()
		
		if bay.quantity > 0:
			# Set the types of cargo in the stack, being careful not to increase quantity
			var legal_cargo = GameData.get_legal_cargo()
			var contraband = GameData.get_illegal_cargo()
			var type_list : Array[int]
			if smuggle:
				contraband.resize(randi_range(1, min(contraband.size(), bay.quantity)))
				type_list.append_array(contraband)
			for i in range(randi_range(0, min(legal_cargo.size(), bay.quantity - type_list.size()))):
				var sel = legal_cargo.pick_random()
				type_list.append(sel)
				legal_cargo.erase(sel)
			bay.set_types(type_list)
			cargo_types.assign(GameConstants.set_merge(cargo_types, type_list))
		
		var num = bay.quantity
		cargo += num


## Adds a random amount of passengers to each floor with random factions
func randomize_passengers(smuggle = false):
	var passenger_list : Array
	
	var limit = GameData.get_passenger_limit()
	var p_request = randi_range(min(limit / 2, floors.size() * 4), min(limit, floors.size() * 10))
	if GameData.is_fatty:
		p_request = randi_range(limit + 1, (limit + 1) * 1.2)
	
	# Constructs an array that represents each floor as a percentage of total passenger count
	var p_count_arr = []
	p_count_arr.resize(floors.size())
	p_count_arr = p_count_arr.map(func(num): return randf())
	p_count_arr = GameConstants.normalize_array(p_count_arr)
	# Changes the array to the number of passengers on each floor
	p_count_arr = p_count_arr.map(func(num): return int(num * p_request))
	var sum = p_count_arr.reduce(func(accum, num): return accum + num)
	if sum < p_request:
		for i in range(p_request - sum):
			p_count_arr[randi_range(0, p_count_arr.size() - 1)] += 1
	
	print("Filled ship with passengers: %s" % [p_count_arr])
	
	
	passengers = 0
	for floor in floors:
		clear_floor(floor)
		var num : int = p_count_arr.pop_front()
		passengers += num
		populate_floor(floor, num)
		passenger_list.append_array(floor.get_children())
	
	passgener_factions_setup(passenger_list, smuggle)


## Places a bunch of people on a floor
func populate_floor(floor: Floor, quantity):
	for pi in range(quantity):
		var person = preload("res://spaceship/characters/person.tscn").instantiate()
		person.floor = floor
		floor.add_child(person)
		person.position = floor.get_random_point()
		#var faction = valid_factions.pick_random()
		#person.set_faction(faction)


## Gives each passenger a faction
func passgener_factions_setup(passenger_list, smuggle):
	var illegal_factions = GameData.get_illegal_factions()
	var legal_factions = GameData.get_legal_factions()
	
	var faction_dict : Dictionary
	
	if smuggle:
		# Randomly pick % of passengers to be criminals
		for i in range(ceili(passengers * GameData.get_criminal_rate())):
			var lucky = passenger_list.pick_random()
			var faction = illegal_factions.pick_random()
			faction_dict[faction] = true
			lucky.set_faction(faction)
			passenger_list.erase(lucky)
	
	# Give the rest random factions
	for p in passenger_list:
		var faction = legal_factions.pick_random()
		faction_dict[faction] = true
		p.set_faction(faction)
	
	factions = faction_dict.keys()


# Deletes all the people on a floor
func clear_floor(floor: Floor):
	for child in floor.get_children():
		child.queue_free()
