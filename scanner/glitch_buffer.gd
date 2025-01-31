extends BackBufferCopy

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.passengers_viewed.connect(glitch)
	EventBus.cargo_viewed.connect(glitch)


func glitch():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_callback(show)
	tween.tween_callback(hide).set_delay(0.2)
