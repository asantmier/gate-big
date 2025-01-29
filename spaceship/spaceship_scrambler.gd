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
	for bay in cargo_bays:
		var legal_cargo = GameData.get_legal_cargo()
		var contraband = GameData.get_illegal_cargo()
		var type_list : Array[int]
		type_list.append_array(legal_cargo)
		if smuggle:
			contraband.resize(randi_range(1, contraband.size()))
			type_list.append_array(contraband)
		#var random_types = bay.random_types(3)
		#type_list = GameConstants.set_merge(type_list, random_types)
		
		bay.randomify()
		bay.set_types(type_list)
		var num = bay.quantity
		cargo += num
		cargo_types.assign(GameConstants.set_merge(cargo_types, type_list))


## Adds a random amount of passengers to each floor with random factions
func randomize_passengers(smuggle = false):
	var passenger_list : Array
	
	passengers = 0
	for floor in floors:
		clear_floor(floor)
		var num = randi_range(4, 10)
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
