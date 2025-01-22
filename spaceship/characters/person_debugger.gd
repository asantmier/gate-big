extends Node2D

@export var person : Person


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Position.global_position = person.floor.curve.get_closest_point(person.floor.to_local(person.global_position))
	if person.wander_target:
		$Target.show()
		$Target.global_position = person.wander_target + person.floor.global_position
	else:
		$Target.hide()
