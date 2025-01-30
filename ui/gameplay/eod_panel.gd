extends Panel

@export var report : Control
@export var brief : Control
#@export var start_button : Control


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.shift_started.connect(hide_panel)
	EventBus.shift_ended.connect(show_panel)
	#EventBus.shift_ended.emit() # Commenting makes this panel not show up in the intro
	show_panel()
	
	report.hide()


func hide_panel():
	hide()


func show_panel():
	brief.hide()
	#start_button.hide()
	show()
	display_report()


func display_report():
	report.show()
	report.hidden.connect(display_brief, CONNECT_ONE_SHOT)


func display_brief():
	brief.show()
