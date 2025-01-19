extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.start_shift.connect(_on_start_shift)


func _on_start_button_pressed():
	EventBus.start_shift.emit()


func _on_start_shift():
	hide()
