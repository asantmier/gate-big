extends Control


func _ready():
	close()


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
