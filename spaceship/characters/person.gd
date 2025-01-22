class_name Person
extends Node2D
## Autonomous NPC behavior

@export var v_anim_curve : Curve
@export var v_anim_max : float = 70.0
@export var wander_speed : float = 50.0
@export var wander_variance : float = 20.0
@export var floor : Floor
var velocity : float = 0.0

var wander_target : Vector2
var last_side : int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Animates walking based on speed
	if velocity != 0:
		$AnimationPlayer.play("bob", -1, v_anim_curve.sample_baked(abs(velocity) / v_anim_max))
	else:
		$AnimationPlayer.play("idle", 0.5)


func _physics_process(delta):
	position.x += velocity * delta


## Returns direction from this person to the target position
func get_side(target):
	if position.x > target.x:
		return -1
	elif position.x < target.x:
		return 1
	else:
		return 0


func _on_wander_state_entered():
	wander_target = floor.get_random_point()
	last_side = get_side(wander_target)
	velocity = (wander_speed + randf_range(-wander_variance, wander_variance)) * get_side(wander_target)


func _on_wander_state_processing(delta):
	if get_side(wander_target) != last_side:
		$StateChart.send_event("wander_finished")


func _on_idle_state_entered():
	velocity = 0
	$StateChart.send_event("start_wander")
