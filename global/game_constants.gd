extends Node

signal volume_changed(percent)

enum {GRIN, FLUFF, ZAPPLE, GREEN_ZAPPLE, AUSPICIOUS_MOO_DENG, OMINOUS_MOO_DENG, EGGPLANT}
#enum {RED_FACTION, ORANGE_FACTION, YELLOW_FACTION, GREEN_FACTION, BLUE_FACTION, INDIGO_FACTION, PURPLE_FACTION}
enum {RED_FACTION, ORANGE_FACTION, YELLOW_FACTION}
const FACTION_COUNT = 3


# Time it takes to type out one letter
var typing_speed := 0.02
# Volume in percentage
var volume : float


func _ready():
	set_volume(0.5)
	print("Debug = %s" % OS.is_debug_build())


func get_typing_length(text):
	var length = text.length()
	return length * typing_speed


func set_volume(value):
	volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	volume_changed.emit(value)


## Returns the union of two arrays as if they were sets
func set_merge(arr1: Array, arr2: Array):
	var dict : Dictionary
	for e in arr1:
		dict[e] = true
	for e in arr2:
		dict[e] = true
	return dict.keys()


func get_all_factions_list() -> Array[int]:
	var arr : Array[int]
	arr.assign(range(0, FACTION_COUNT))
	return arr


func get_all_cargo_list() -> Array[int]:
	var arr : Array[int]
	arr.assign(range(0, 7))
	return arr
