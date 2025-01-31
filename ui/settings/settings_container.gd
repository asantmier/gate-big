extends VBoxContainer


func _on_settings_button_pressed():
	%PressSound.play()


func _on_settings_button_mouse_entered():
	%HoverSound.play()


func _on_volume_button_pressed():
	%PressSound.play()


func _on_volume_button_mouse_entered():
	%HoverSound.play()
