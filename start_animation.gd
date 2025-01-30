extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.game_won.connect(_on_game_won)
	if not GameConstants.skip_intro:
		EventBus.game_begun.connect(_on_game_begun)
		play("prep_title")
		


func _on_game_begun():
	play("startup")


func _on_game_won():
	play("prep_title")
