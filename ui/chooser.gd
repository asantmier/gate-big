extends Node


func _ready():
	EventBus.ship_focused.connect(enable_buttons)
	EventBus.pass_ship.connect(disable_buttons)
	EventBus.kill_ship.connect(disable_buttons)


func enable_buttons():
	%"Eliminate Button".disabled = false
	%"Pass Button".disabled = false


func disable_buttons():
	%"Eliminate Button".disabled = true
	%"Pass Button".disabled = true


func _on_pass_button_pressed():
	EventBus.pass_ship.emit()


func _on_eliminate_button_pressed():
	EventBus.kill_ship.emit()
