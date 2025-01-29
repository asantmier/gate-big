extends Node

@export var label : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	if not label:
		label = get_parent()
		
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(label, "visible_characters", label.text.length(), 0.5)
	tween.tween_property(label, "visible_characters", label.text.length() - 1, 0.5)
