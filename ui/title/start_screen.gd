extends Control

#@export var hide_in_debug := false


# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	#if OS.is_debug_build() and hide_in_debug:
	if GameConstants.skip_intro:
		#GameConstants.skip_intro = true
		EventBus.game_begun.emit.call_deferred()
		hide()



func _on_button_pressed():
	EventBus.game_begun.emit()
	$AnimationPlayer.play("fade_out")
	#hide()
