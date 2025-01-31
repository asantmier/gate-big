extends Node


func _ready():
	EventBus.ship_focused.connect(reset)
	EventBus.ship_passed.connect(disable_buttons)
	EventBus.ship_killed.connect(disable_buttons)
	EventBus.time_up.connect(disable_buttons)
	EventBus.reprimand_limit_reached.connect(disable_buttons)
	EventBus.shift_started.connect(disable_buttons)
	reset()


func reset():
	%Safety.disabled = false
	%Safety.button_pressed = false
	%"Eliminate Button".disabled = true
	%"Pass Button".disabled = true


func disable_buttons():
	%Safety.disabled = true
	%"Eliminate Button".disabled = true
	%"Pass Button".disabled = true


func _on_pass_button_pressed():
	EventBus.ship_passed.emit()
	%Buttonsound1.play()


func _on_eliminate_button_pressed():
	EventBus.ship_killed.emit()
	%Buttonsound1.play()


func _on_safety_toggled(toggled_on):
	if toggled_on:
		%SafetySwitchSound.play()
	else:
		%SafetySwitchSoundOff.play()
	%"Eliminate Button".disabled = not toggled_on
	%"Pass Button".disabled = not toggled_on
