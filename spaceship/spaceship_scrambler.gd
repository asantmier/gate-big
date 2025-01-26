extends Node2D

@export var floors : Array[Floor]
@export var cargo_bays : Array[Cargo]

var passengers : int
var cargo : int
var factions : Array[int]
var cargo_types : Array[int]


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
	randomize_passengers()
	randomize_cargo()
	submit_manifest()


func randomize_cargo():
	cargo = 0
	for bay in cargo_bays:
		bay.randomify()
		bay.set_types(bay.random_types(3))
		var num = bay.quantity
		cargo += num


# Adds a random amount of passengers to each floor
func randomize_passengers():
	passengers = 0
	for floor in floors:
		clear_floor(floor)
		var num = randi_range(4, 10)
		passengers += num
		populate_floor(floor, num)


# Places a bunch of people on a floor
func populate_floor(floor: Floor, quantity):
	for pi in range(quantity):
		var person = preload("res://spaceship/characters/person.tscn").instantiate()
		person.floor = floor
		floor.add_child(person)
		person.position = floor.get_random_point()
		person.set_faction(person.random_faction())


# Deletes all the people on a floor
func clear_floor(floor: Floor):
	for child in floor.get_children():
		child.queue_free()
