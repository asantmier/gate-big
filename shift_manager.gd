extends Node2D


var spaceship

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.start_shift.connect(_on_start_shift)
	EventBus.pass_ship.connect(_on_pass_ship)


func _on_start_shift():
	spaceship = preload("res://spaceship.tscn").instantiate()
	add_child(spaceship)
	$AnimationPlayer.play("float_in")


func _on_pass_ship():
	$AnimationPlayer.play("float_out")
	queue_free()
