extends VBoxContainer

#const intro_message : String = "Rate of newcomers has lessened thanks to the new regulations, and \
#the Empire is slowly eliminating all threats in the planet. However, our spies have reported that \
#some ship operators are bringing in more cargo than they should be, or even smuggling in illegal items.\n
#Starting from today, check the cargo of each ship, and ensure that no illegal goods are onboard, \
#or that they are not carrying any more cargo than stated in their manifest. If any ship does \
#not abide with either of these regulations:\n
#Eliminate them."
const usual_title := "[Message to all B.I.G. personnel]"
const intro_title : String = "[Welcome B.I.G. agent]"
const final_title: String = "[Empire Secured]"
const intro_message : String = "\
You have been assigned as a probationary agent for B.I.G. For the next 5 days, you will be \
inspecting ships trying to enter the planet KA-414 to ensure they abide our ever changing laws. \
Each ship will provide a Manifest detailing the amount of passengers and cargo they carry. Ensure the manifest is correct.
Use the Life and Cargo scanner to make sure that these ships are carrying exactly what \
they claim. No more, no less. 
If a ship follows the law, turn the key and press the Blue Button. If they \
do not, turn the key and press the Red Button to annihilate them with the B.I.G. Gun.
You have limited room for error.\n
Secure the Empire, and make the Empire Great Again! 
-Galactic Commander Tronel Dhump\
"
const outro_message : String = "You have successfully completed your probationary period as a B.I.G.\
 agent. For your performance, you will be considered for promotion to a full-time ship inspector.\n
For now, you are relieved of duty and may rest!\
"
const messages : Array[String]= [
	"if you see this i fucked up (shift0)",
	
	"The rate of hostile entities entering the planet has greatly decreased thanks to the Empire’s \
new directive. However, there is a major overcrowding problem with the influx of civilians \
trying to colonize the planet.
Starting from today, ships exceeding the passenger or cargo limit must be eradicated to preserve \
the peace. If any ship dares disobey:\n
Eliminate them.",

	"Rate of newcomers has lessened thanks to the new regulations. However, our spies have reported \
that some ship operators are aiding enemies of the state, or even smuggling in illegal items.
Starting from today, check the cargo of each ship, and ensure that no banned goods are onboard, \
nor any banned factions. If any ship does not abide with our regulations:\n
Eliminate them.",

	"To all newly assigned B.I.G. agents, this is the penultimate day for your probationary period. \
You have all been doing good work so far, so keep up the pace.
For the time being, there are no new regulations to be added to the directive. Maintain all \
current protocol and continue to meet your quotas.\n
Fail to do so, and you will be decommissioned.",

	"To all newly assigned B.I.G. agents, this is the final day for your probationary period. \
You have all been doing outstanding work. We expect no less.
There are no new regulations, so maintain all current inspection protocols.
A large number of migrants is expected during your next shift. Act fast to meet your increased quota \
and you will finally pass your probationary period and become full-fledged workers of the B.I.G.\n
Fail to do so, and you will be decommissioned.",

	"if you see this i fucked up (shift5)",
]

@export var show_on_finish : Control

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(_on_visibility_changed)
	#hide()
	#show()


func display():
	%Title.text = get_title()
	%News.text = get_news()
	
	skip()
	show_on_finish.hide()
	$"VBoxContainer/News/Blinking Caret Component".stop()
	tween = get_tree().create_tween()
	tween.tween_callback($TypingSounds.start_playing)
	tween.tween_property(%News, "visible_ratio", 1, GameConstants.get_typing_length(%News.text)).from(0)
	tween.tween_callback($TypingSounds.stop_playing)
	tween.tween_callback(show_on_finish.show).set_delay(0.5)
	tween.tween_callback($"VBoxContainer/News/Blinking Caret Component".play)


func get_title() -> String:
	if GameData.shift == 0:
		return intro_title
	if GameData.is_final_shift():
		return final_title
	return usual_title


func get_news() -> String:
	if GameData.shift == 0:
		return intro_message
	if GameData.is_final_shift():
		return outro_message
	return messages[GameData.shift]


func _on_visibility_changed():
	if visible:
		display()
	else:
		skip()

func _input(event):
	if event.is_action_pressed("skip"):
		skip()


func skip():
	if tween and tween.is_valid():
		tween.custom_step(1000)
		tween.kill()


func _on_start_button_pressed():
	hide()
