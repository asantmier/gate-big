extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.reprimand_issued.connect(play)
	hide()


func play():
	show()
	get_tree().call_group("warn_light", "play", "pulse")
