extends VBoxContainer

@export var show_on_finish : Control

signal display_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(_on_visibility_changed)


func display():
	show_on_finish.hide()
	var tween = get_tree().create_tween()
	tween.tween_property(%News, "visible_ratio", 1, GameConstants.get_typing_length(%News.text)).from(0)
	tween.tween_callback(show_on_finish.show).set_delay(0.5)


func _on_visibility_changed():
	if visible:
		display()
