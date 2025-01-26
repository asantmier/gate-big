extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.reprimand_limit_reached.connect(_on_reprimand_limit_reached)
	hide()


func _on_reprimand_limit_reached():
	show()
