extends Node

signal volume_changed(percent)




# Time it takes to type out one letter
var typing_speed := 0.02
# Volume in percentage
var volume : float


func _ready():
	set_volume(0.5)
	print(OS.is_debug_build())


func get_typing_length(text):
	var length = text.length()
	return length * typing_speed


func set_volume(value):
	volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	volume_changed.emit(value)
	
