extends Button


func _ready():
	EventBus.shift_started.connect(set_disabled.bind(true))
	EventBus.shift_ended.connect(set_disabled.bind(false))


func _on_pressed():
	EventBus.shift_started.emit()
	EventBus.ship_summoned.emit()
