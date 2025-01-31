extends Node

signal volume_changed(percent)

var skip_intro := false

enum {GRIN, FLUFF, ZAPPLE, GREEN_ZAPPLE, EGGPLANT, AUSPICIOUS_MOO_DENG, OMINOUS_MOO_DENG}
#enum {RED_FACTION, ORANGE_FACTION, YELLOW_FACTION, GREEN_FACTION, BLUE_FACTION, INDIGO_FACTION, PURPLE_FACTION}
enum {BLUE_CY_FACTION, BLUE_MG_FACTION, BLUE_YL_FACTION,
	GREEN_CY_FACTION, GREEN_MG_FACTION, GREEN_YL_FACTION,
	RED_CY_FACTION, RED_MG_FACTION, RED_YL_FACTION,
	 }
const FACTION_COUNT = 9


# Time it takes to type out one letter
var typing_speed := 0.02
# Volume in percentage
var volume : float


func _ready():
	if not OS.is_debug_build():
		skip_intro = false
	
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


## normalizes the array so its elements sum to 1
func normalize_array(array : Array) -> Array:
	var mag = array.reduce(func(accum, num): return accum + num) as float
	mag = mag
	return array.map(func(num): return num / mag)
