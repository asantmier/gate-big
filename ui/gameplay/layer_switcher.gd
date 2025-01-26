extends Node

func _ready():
	EventBus.passengers_viewed.connect(_on_passengers_viewed)
	EventBus.cargo_viewed.connect(_on_cargo_viewed)
	EventBus.systems_viewed.connect(_on_systems_viewed)


func _on_passenger_button_pressed():
	EventBus.passengers_viewed.emit()


func _on_cargo_button_pressed():
	EventBus.cargo_viewed.emit()


func _on_system_button_pressed():
	EventBus.systems_viewed.emit()


func _on_passengers_viewed():
	pass


func _on_cargo_viewed():
	pass


func _on_systems_viewed():
	pass
