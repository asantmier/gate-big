extends Panel

@export var report : Control
@export var brief : Control
#@export var start_button : Control


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.shift_started.connect(hide_panel)
	EventBus.shift_ended.connect(show_panel)
	#show_panel()
	
	#report.hide.call_deferred()
	EventBus.game_begun.connect(on_game_begun)
	
	EventBus.game_won.connect(hide_panel)

func on_game_begun():
	$Ambience.play()
	report.hide()
	brief.show()
	show()

func hide_panel():
	hide()
	$Ambience.stop()


func show_panel():
	brief.hide()
	display_report()
	$Ambience.play()
	show()


func display_report():
	report.show()
	report.hidden.connect(display_brief, CONNECT_ONE_SHOT)


func display_brief():
	brief.show()
