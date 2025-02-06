extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	EventBus.reprimand_issued.connect(_on_reprimand_issued)


func _on_reprimand_issued():
	EventBus.lock_shift.emit()
	%RepCount.text = str(GameData.max_reprimands - GameData.reprimands)
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
		_on_animation_player_animation_finished("")
	$AnimationPlayer.play("type")
	show()


func _on_animation_player_animation_finished(anim_name):
	EventBus.unlock_shift.emit()
	hide()
