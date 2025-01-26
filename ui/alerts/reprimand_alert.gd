extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	EventBus.reprimand_issued.connect(_on_reprimand_issued)


func _on_reprimand_issued():
	%RepCount.text = str(GameData.max_reprimands - GameData.reprimands)
	show()


func _on_animation_player_animation_finished(anim_name):
	hide()
