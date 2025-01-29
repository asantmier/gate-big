extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.game_begun.connect(_on_game_begun)
	play("prep_title")


func _on_game_begun():
	play("startup")
