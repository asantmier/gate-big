extends Node

@export_enum("liar", "smuggler", "fatty") var condition : String = "liar"


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.time_up.connect(_on_time_out)
	EventBus.reprimand_issued.connect(_on_reprimand_issued)


func _on_reprimand_issued():
	if GameData.is_liar and condition == "liar":
		play()
	elif GameData.is_smuggler and condition == "smuggler":
		play()
	elif GameData.is_fatty and condition == "fatty":
		play()


func play():
	var parent = get_parent()
	EventBus.lock_shift.emit()
	var tween := get_tree().create_tween().set_loops(3).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(parent, "modulate", Color.RED, 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property(parent, "modulate", Color.WHITE, 0.5).set_ease(Tween.EASE_IN)
	var callback = func(): EventBus.unlock_shift.emit()
	tween.finished.connect(callback)
	

func _on_time_out():
	# because time outs issue a reprimand, but aren't related to the player 
	# mistaking the ship's legality, don't play the highlight animation
	EventBus.reprimand_issued.disconnect(_on_reprimand_issued)
	await EventBus.reprimand_issued
	EventBus.reprimand_issued.connect(_on_reprimand_issued)
