extends VBoxContainer

const intro_message : String = "Rate of newcomers has lessened thanks to the new regulations, and \
the Empire is slowly eliminating all threats in the planet. However, our spies have reported that \
some ship operators are bringing in more cargo than they should be, or even smuggling in illegal items.\n
Starting from today, check the cargo of each ship, and ensure that no illegal goods are onboard, \
or that they are not carrying any more cargo than stated in their manifest. If any ship does \
not abide with either of these regulations:\n
Eliminate them."
const outro_message : String = "Bye"
const messages : Array[String]= [
	"shift0",
	"Shift 1 News!",
	"Shift 2 News!",
	"Shift 3 News!",
	"Shift 4 News!",
	"shift5",
]

@export var show_on_finish : Control

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(_on_visibility_changed)
	hide()
	show()


func display():
	%News.text = get_news()
	
	if tween:
		tween.kill()
	show_on_finish.hide()
	$"VBoxContainer/News/Blinking Caret Component".stop()
	tween = get_tree().create_tween()
	tween.tween_property(%News, "visible_ratio", 1, GameConstants.get_typing_length(%News.text)).from(0)
	tween.tween_callback(show_on_finish.show).set_delay(0.5)
	tween.tween_callback($"VBoxContainer/News/Blinking Caret Component".play)


func get_news() -> String:
	if GameData.shift == 0:
		return intro_message
	if GameData.is_final_shift():
		return outro_message
	return messages[GameData.shift]


func _on_visibility_changed():
	if visible:
		display()


func _input(event):
	if event.is_action_pressed("skip"):
		if tween and tween.is_valid():
			tween.kill()
			%News.visible_ratio = 1
			show_on_finish.show()
			$"VBoxContainer/News/Blinking Caret Component".play()


func _on_start_button_pressed():
	hide()
