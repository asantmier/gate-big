extends AudioStreamPlayer

var tween : Tween

func start_playing():
	tween = create_tween().set_loops()
	tween.tween_callback(play_one)
	tween.tween_interval(GameConstants.typing_speed * 5)


func stop_playing():
	tween.kill()


func play_one():
	var aud := preload("res://one_off_sound.tscn").instantiate()
	aud.stream = stream
	aud.volume_db = volume_db + randf_range(-2.1, 2.1)
	aud.pitch_scale = randf_range(0.95, 1.15)
	add_child(aud)
