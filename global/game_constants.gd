extends Node

# Time it takes to type out one letter
var typing_speed := 0.02


func get_typing_length(text):
	var length = text.length()
	return length * typing_speed
