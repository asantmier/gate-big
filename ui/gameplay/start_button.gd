extends Button


func _ready():
	EventBus.shift_started.connect(set_disabled.bind(true))
	EventBus.shift_ended.connect(set_disabled.bind(false))
	EventBus.shift_ended.connect(_on_shift_end)


func _on_pressed():
	$PressSound.play()
	if GameData.is_final_shift():
		EventBus.game_won.emit()
		print("won game")
	else:
		EventBus.shift_started.emit()
		EventBus.ship_summoned.emit()


func _on_shift_end():
	if GameData.is_final_shift():
		text = "END TRAINING"
	else:
		text = "BEGIN SHIFT"


func _on_mouse_entered():
	$HoverSound.play()
