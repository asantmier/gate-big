extends Control

@export var settings_animation : AnimationPlayer
@export var volume_slider : Control

func _ready():
	close()
	if volume_slider:
		volume_slider.visible = false


func toggle():
	if visible:
		close()
	else:
		open()


func open():
	get_tree().paused = true
	show()
	settings_animation.play("blink")


func close():
	get_tree().paused = false
	hide()
	settings_animation.play("RESET")


func _on_resume_pressed():
	%PressSound.play()
	close()


func _on_quit_pressed():
	%PressSound.play()
	get_tree().quit()


func _on_volume_button_pressed():
	volume_slider.visible = not volume_slider.visible


func _on_resume_mouse_entered():
	%HoverSound.play()


func _on_quit_mouse_entered():
	%HoverSound.play()
