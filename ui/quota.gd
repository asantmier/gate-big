extends Label
## Displays the quota


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "%d/%d" % [GameData.processed, GameData.get_quota()]
