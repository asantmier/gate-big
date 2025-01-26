extends Node2D

@export var passenger_icon : Node2D
@export var cargo_icon : Node2D

func _ready():
	EventBus.passengers_viewed.connect(passengers)
	EventBus.cargo_viewed.connect(cargo)
	#EventBus.systems_viewed.connect(systems)


func passengers():
	passenger_icon.show()
	cargo_icon.hide()


func cargo():
	cargo_icon.show()
	passenger_icon.hide()
