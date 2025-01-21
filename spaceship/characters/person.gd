extends Node2D


@export var v_anim_curve : Curve
@export var v_anim_max : float = 10.0
var velocity : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity != 0:
		$AnimationPlayer.play("bob", -1, v_anim_curve.sample_baked(abs(velocity) / v_anim_max))
	else:
		$AnimationPlayer.play("RESET")


func _physics_process(delta):
	position.x += velocity * delta


func _on_h_slider_value_changed(value):
	velocity = value
