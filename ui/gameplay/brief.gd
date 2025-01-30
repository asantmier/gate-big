extends VBoxContainer

@export var show_on_finish : Control

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(_on_visibility_changed)
	hide()
	show()


func display():
	if tween:
		tween.kill()
	show_on_finish.hide()
	tween = get_tree().create_tween()
	tween.tween_property(%News, "visible_ratio", 1, GameConstants.get_typing_length(%News.text)).from(0)
	tween.tween_callback(show_on_finish.show).set_delay(0.5)


func _on_visibility_changed():
	if visible:
		display()

func _input(event):
	if event.is_action_pressed("skip"):
		if tween:
			tween.kill()
			%News.visible_ratio = 1
			show_on_finish.show()


func _on_start_button_pressed():
	hide()
