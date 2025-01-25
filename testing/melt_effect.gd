extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.reprimand_limit_reached.connect(do_thing)


func do_thing():
	show()
	$AnimationPlayer.play("wait")
	$AnimationPlayer.queue("melt")
