extends VBoxContainer

signal closed


# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(_on_visibility_changed)


func display():
	%ReprimandsLeft.text = "%d" % (GameData.max_reprimands - GameData.reprimands)


func _on_close_report_pressed():
	hide()
	closed.emit()


func _on_visibility_changed():
	if visible:
		display()
