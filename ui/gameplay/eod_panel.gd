extends Panel

@export var report : Control
@export var brief : Control
#@export var start_button : Control


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.shift_started.connect(hide_panel)
	EventBus.shift_ended.connect(show_panel)
	show_panel()
	
	report.hide()
	#EventBus.game_begun.connect(report.hide)
	
	EventBus.game_won.connect(hide_panel)


func hide_panel():
	hide()


func show_panel():
	brief.hide()
	display_report()
	show()


func display_report():
	report.show()
	report.hidden.connect(display_brief, CONNECT_ONE_SHOT)


func display_brief():
	brief.show()
