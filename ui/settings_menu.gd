extends Control

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


func close():
	get_tree().paused = false
	hide()


func _on_resume_pressed():
	close()


func _on_quit_pressed():
	get_tree().quit()


func _on_volume_button_pressed():
	volume_slider.visible = not volume_slider.visible
