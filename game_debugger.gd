extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$VBoxContainer/IsLiar.text = "IsLiar:%s" % GameData.is_liar
	$VBoxContainer/Shift.text = "Shift:%d" % GameData.shift
	$VBoxContainer/LiedProcessed.text = "L:%d(%d) P:%d(%d)" % [GameData.lied, GameData.get_liars_quota(), GameData.processed, GameData.get_quota()]
