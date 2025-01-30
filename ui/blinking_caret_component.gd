extends Node

@export var auto := true
@export var label : Control

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	if not label:
		label = get_parent()
	
	if auto:
		tween = get_tree().create_tween().set_loops()
		tween.tween_property(label, "visible_characters", label.text.length(), 0.5)
		tween.tween_property(label, "visible_characters", label.text.length() - 1, 0.5)


func play():
	stop()
	label.text += "_"
	tween = get_tree().create_tween().set_loops()
	tween.tween_property(label, "visible_characters", label.text.length() - 1, 0.5).from(label.text.length())
	tween.tween_property(label, "visible_characters", label.text.length(), 0.5)


func stop():
	label.text.trim_suffix("_")
	if tween:
		tween.kill()
