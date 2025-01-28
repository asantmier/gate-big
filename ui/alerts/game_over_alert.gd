extends Control

var waiting

# Called when the node enters the scene tree for the first time.
func _ready():
	waiting = false
	EventBus.reprimand_limit_reached.connect(_on_reprimand_limit_reached)
	hide()


func _on_reprimand_limit_reached():
	waiting = true
	#show()


func _on_reprimand_alert_hidden():
	if waiting:
		$AnimationPlayer.play("type")
		show()
