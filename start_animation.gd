extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.return_title.connect(_on_game_won)
	play("RESET")
	#if not GameConstants.skip_intro:
	EventBus.game_begun.connect(_on_game_begun)
	play("prep_title")
		


func _on_game_begun():
	play("startup")
	if GameConstants.skip_intro:
		advance(current_animation_length)


func _on_game_won():
	play("prep_title")
