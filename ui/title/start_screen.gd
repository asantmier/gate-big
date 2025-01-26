extends Control

@export var hide_in_debug := false


# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	if OS.is_debug_build() and hide_in_debug:
		hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	hide()
