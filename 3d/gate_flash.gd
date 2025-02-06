extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.gate_touched.connect(prep_warp)


func prep_warp():
	#await EventBus.ship_left_gate
	play("gate_flash")
