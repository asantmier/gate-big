extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.ship_focused.connect(_on_ship_focused)
	EventBus.ship_left_gate.connect(_on_ship_left_gate)


func _on_ship_focused():
	text = "Passengers: %d" % GameData.ship_info.Passengers


func _on_ship_left_gate():
	pass
