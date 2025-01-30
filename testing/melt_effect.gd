extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.reprimand_limit_reached.connect(do_thing)


func do_thing():
	show()
	$AnimationPlayer.play("wait")
	$AnimationPlayer.queue("melt")
	$AnimationPlayer.queue("game_over")


func _input(event):
	if OS.is_debug_build() and event is InputEventKey:
		if event.keycode == KEY_F9:
			do_thing()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "game_over":
		EventBus.game_lost.emit()
