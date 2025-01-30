extends Node2D
## Hides/displays content when the scanner's layer changes


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.passengers_viewed.connect(passengers)
	EventBus.cargo_viewed.connect(cargo)
	EventBus.systems_viewed.connect(systems)
	
	# Defaults the visible layer on the first frame
	var callable = EventBus.passengers_viewed.emit
	get_tree().process_frame.connect(callable, CONNECT_ONE_SHOT)


func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and not event.is_echo() and event.keycode == KEY_1:
			EventBus.passengers_viewed.emit()
		if event.is_pressed() and not event.is_echo() and event.keycode == KEY_2:
			EventBus.cargo_viewed.emit()
		#if event.is_pressed() and not event.is_echo() and event.keycode == KEY_3:
			#EventBus.systems_viewed.emit()


func passengers():
	get_tree().call_group("cargo", "hide")
	get_tree().call_group("passengers", "show")
	get_tree().call_group("systems", "hide")


func cargo():
	get_tree().call_group("cargo", "show")
	get_tree().call_group("passengers", "hide")
	get_tree().call_group("systems", "hide")


func systems():
	get_tree().call_group("cargo", "hide")
	get_tree().call_group("passengers", "hide")
	get_tree().call_group("systems", "show")
	
