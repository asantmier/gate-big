extends Node2D

@export var floors : Array[Floor]

var passengers : int


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.ship_summoned.connect(scramble_ship)
	scramble_ship()


func submit_manifest():
	var info_dict : Dictionary
	info_dict.Passengers = passengers
	
	GameData.ship_info = info_dict


func scramble_ship():
	randomize_passengers()
	submit_manifest()


func randomize_passengers():
	passengers = 0
	for floor in floors:
		clear_floor(floor)
		var num = randi_range(4, 10)
		passengers += num
		populate_floor(floor, num)


func populate_floor(floor: Floor, quantity):
	for pi in range(quantity):
		var person = preload("res://spaceship/characters/person.tscn").instantiate()
		person.floor = floor
		floor.add_child(person)
		person.position = floor.get_random_point()


func clear_floor(floor: Floor):
	for child in floor.get_children():
		child.queue_free()
