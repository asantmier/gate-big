extends Node3D

@export var speed := 5.0
@export_enum("X", "Y", "Z") var axis: int

var target : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_parent_node_3d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match axis:
		0:
			target.rotate_x(deg_to_rad(speed * delta))
		1:
			target.rotate_y(deg_to_rad(speed * delta))
		2:
			target.rotate_z(deg_to_rad(speed * delta))
