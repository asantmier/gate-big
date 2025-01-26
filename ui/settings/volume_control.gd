extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	GameConstants.volume_changed.connect(_on_volume_changed)
	%Volume.set_value_no_signal(GameConstants.volume)


func _on_volume_changed(value):
	%Volume.set_value_no_signal(value)


func _on_volume_value_changed(value):
	GameConstants.set_volume(value)
