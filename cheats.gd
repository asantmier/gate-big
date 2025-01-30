extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func _input(event):
	if event.is_action_pressed("open_cheats"):
		visible = not visible


func _on_rep_sub_pressed():
	GameData.revoke_reprimand()


func _on_rep_add_pressed():
	GameData.issue_reprimand()


func _on_t_1_pressed():
	EventBus.cheat_time.emit(5)
