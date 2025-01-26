class_name Person
extends Node2D
## Autonomous NPC behavior

@export var v_anim_curve : Curve
@export var v_anim_max : float = 70.0
@export var wander_speed : float = 50.0
@export var wander_variance : float = 20.0
@export var floor : Floor
@export var sprites1 : Array[Texture2D]
@export var sprites2 : Array[Texture2D]

var velocity : float = 0.0

var wander_target : Vector2
var last_side : int

var variant : int # Sprite variant


# Called when the node enters the scene tree for the first time.
func _ready():
	variant = randi_range(0, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Animates walking based on speed
	var custom_speed = v_anim_curve.sample_baked(abs(velocity) / v_anim_max)
	if velocity > 0:
		$AnimationPlayer.play("walk_right", -1, custom_speed)
	elif velocity < 0:
		$AnimationPlayer.play("walk_left", -1, custom_speed)
	else:
		$AnimationPlayer.play("idle")


func _physics_process(delta):
	position.x += velocity * delta


func set_faction(id):
	var tex : Texture2D
	match variant:
		0:
			tex = sprites1[id]
		1:
			tex = sprites2[id]
	$Graphics.texture = tex


func faction_count():
	return sprites1.size()


func random_faction():
	return randi_range(0, faction_count() - 1)


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
