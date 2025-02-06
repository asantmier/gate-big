extends Label

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.ship_focused.connect(_on_ship_focused)
	EventBus.ship_left_gate.connect(_on_ship_left_gate)
	EventBus.shift_started.connect(_on_shift_started)
	EventBus.ship_summoned.connect(_on_ship_summoned)


func _on_ship_focused():
	var lies := {}
	if GameData.is_liar:
		lies = GameData.get_lies()
	var passenger = GameData.ship_info.Passengers + lies.get("Passengers", 0)
	var cargo = GameData.ship_info.Cargo + lies.get("Cargo", 0)
	if GameData.is_fatty:
		passenger = randi_range(GameData.get_passenger_limit() - 5, GameData.get_passenger_limit())
		cargo = randi_range(GameData.get_cargo_limit() - 5, GameData.get_cargo_limit())
	text = ""
	text += "Passengers: %d" % passenger
	text += "\n"
	text += "Cargo: %d" % cargo
	
	
	if tween:
		tween.kill()
	$"Blinking Caret Component".stop()
	tween = get_tree().create_tween()
	tween.tween_callback(%TypingSounds.start_playing)
	tween.tween_property(self, "visible_ratio", 1, GameConstants.get_typing_length(text)).from(0)
	tween.tween_callback(%TypingSounds.stop_playing)
	tween.tween_callback($"Blinking Caret Component".play)


func _on_ship_left_gate():
	pass


func _on_shift_started():
	text = ""


func _on_ship_summoned():
	if tween:
		tween.kill()
	$"Blinking Caret Component".stop()
	tween = get_tree().create_tween()
	tween.tween_property(self, "visible_ratio", 0, GameConstants.get_typing_length(text)).from_current()
	tween.tween_property(self, "text", "", 0)
