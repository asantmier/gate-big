extends AnimatedSprite3D


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.cannon_fired.connect(play)
