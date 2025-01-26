extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.reprimand_issued.connect(alert_reprimand)
	EventBus.reprimand_limit_reached.connect(alert_game_over)


func alert_reprimand():
	$AnimationPlayer.play("toast")


func alert_game_over():
	$AnimationPlayer.queue("toast2")
