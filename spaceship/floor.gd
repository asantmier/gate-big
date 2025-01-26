class_name Floor
extends Path2D
## Defines an area passengers can walk in



## Returns a random point on the path
func get_random_point() -> Vector2:
	var length := curve.get_baked_length()
	var random_position := randf_range(0, length)
	var random_point := curve.sample_baked(random_position)
	return random_point
