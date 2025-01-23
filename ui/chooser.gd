extends Node


func _ready():
	EventBus.ship_focused.connect(enable_buttons)
	EventBus.ship_passed.connect(disable_buttons)
	EventBus.ship_killed.connect(disable_buttons)


func enable_buttons():
	%"Eliminate Button".disabled = false
	%"Pass Button".disabled = false


func disable_buttons():
	%"Eliminate Button".disabled = true
	%"Pass Button".disabled = true


func _on_pass_button_pressed():
	EventBus.ship_passed.emit()


func _on_eliminate_button_pressed():
	EventBus.ship_killed.emit()
