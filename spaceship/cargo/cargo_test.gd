extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Cargo.quantity = 5
	$SpinBox.max_value = $Cargo.type_count()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_R and event.pressed:
			$Cargo.randomify()
			print($Cargo.quantity)
		if event.keycode == KEY_T and event.pressed:
			$Cargo.randomify_large()
			print($Cargo.quantity)
		if event.keycode == KEY_Y and event.pressed:
			$Cargo.randomify_small()
			print($Cargo.quantity)


func _on_type_pressed():
	$Cargo.set_types($Cargo.random_types($SpinBox.value))
