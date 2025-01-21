extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.passengers_viewed.connect(passengers)
	EventBus.cargo_viewed.connect(cargo)
	EventBus.systems_viewed.connect(systems)


func passengers():
	text = "LIFE"


func cargo():
	text = "CRGO"


func systems():
	text = "SYST"
