extends VBoxContainer

signal closed

var passed_this_shift := 0
var killed_this_shift := 0
var mistakes_this_shift := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(_on_visibility_changed)
	EventBus.ship_passed.connect(_on_ship_passed)
	EventBus.ship_killed.connect(_on_ship_killed)
	EventBus.reprimand_issued.connect(_on_mistake)
	EventBus.shift_started.connect(_on_shift_start)


func display():
	%ReprimandsLeft.text = "%d" % (GameData.max_reprimands - GameData.reprimands)
	%KilledLabel.text = "%d" % killed_this_shift
	%PassedLabel.text = "%d" % passed_this_shift
	%MistakesLabel.text = "%d" % mistakes_this_shift


func _on_close_report_pressed():
	hide()
	closed.emit()


func _on_visibility_changed():
	if visible:
		display()


func _on_shift_start():
	passed_this_shift = 0
	killed_this_shift = 0
	mistakes_this_shift = 0


func _on_ship_passed():
	if not GameData.is_ship_bad():
		passed_this_shift += 1


func _on_ship_killed():
	if GameData.is_ship_bad():
		killed_this_shift += 1


func _on_mistake():
	mistakes_this_shift += 1
