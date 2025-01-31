extends VBoxContainer

signal closed

var passed_this_shift := 0
var killed_this_shift := 0
var mistakes_this_shift := 0

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(_on_visibility_changed)
	EventBus.ship_passed.connect(_on_ship_passed)
	EventBus.ship_killed.connect(_on_ship_killed)
	EventBus.reprimand_issued.connect(_on_mistake)
	EventBus.shift_started.connect(_on_shift_start)
	EventBus.time_up.connect(_on_time_up)
	display()


func display():
	%ReprimandsLeft.text = "%d" % (GameData.max_reprimands - GameData.reprimands)
	%KilledLabel.text = "%d" % killed_this_shift
	%PassedLabel.text = "%d" % passed_this_shift
	%MistakesLabel.text = "%d" % mistakes_this_shift
	if mistakes_this_shift == 0 and %OutOfTimeLabel.visible == false:
		%FlawlessLabel.show()
		var has_reprimand = GameData.reprimands > 0
		if has_reprimand:
			%ForgivenessLabel.show()
		GameData.revoke_reprimand()
	
	tween = create_tween()
	%KilledLabel.hide()
	tween.tween_callback(%KilledLabel.show).set_delay(1.5)
	%StatsVSeparator.hide()
	tween.tween_callback(%StatsVSeparator.show)
	%KilledTitle.hide()
	tween.tween_callback(%KilledTitle.show)
	%PassedLabel.hide()
	tween.tween_callback(%PassedLabel.show).set_delay(0.5)
	%PassedTitle.hide()
	tween.tween_callback(%PassedTitle.show)
	%MistakesLabel.hide()
	tween.tween_callback(%MistakesLabel.show).set_delay(0.5)
	%MistakesTitle.hide()
	tween.tween_callback(%MistakesTitle.show)
	if %OutOfTimeLabel.visible:
		%OutOfTimeLabel.hide()
		tween.tween_callback(%OutOfTimeLabel.show).set_delay(1)
	if %FlawlessLabel.visible:
		%FlawlessLabel.hide()
		tween.tween_callback(%FlawlessLabel.show).set_delay(1)
	if %ForgivenessLabel.visible:
		%ForgivenessLabel.hide()
		tween.tween_callback(%ForgivenessLabel.show).set_delay(0.5)
	%ReprimandsTitle.hide()
	tween.tween_callback(%ReprimandsTitle.show).set_delay(1)
	%ReprimandsLeft.hide()
	tween.tween_callback(%ReprimandsLeft.show).set_delay(1)
	%CloseReport.hide()
	tween.tween_callback(%CloseReport.show).set_delay(1)


func _input(event):
	if event.is_action_pressed("skip"):
		if tween and tween.is_valid():
			tween.custom_step(100)


func _on_close_report_pressed():
	%PressSound.play()
	hide()
	closed.emit()


func _on_visibility_changed():
	if visible:
		display()


func _on_shift_start():
	passed_this_shift = 0
	killed_this_shift = 0
	mistakes_this_shift = 0
	%OutOfTimeLabel.hide()
	%FlawlessLabel.hide()
	%ForgivenessLabel.hide()


func _on_ship_passed():
	if not GameData.is_ship_bad():
		passed_this_shift += 1


func _on_ship_killed():
	if GameData.is_ship_bad():
		killed_this_shift += 1


func _on_mistake():
	mistakes_this_shift += 1


func _on_time_up():
	# Since time up adds a mistake through the reprimand, this removes the mistake
	%OutOfTimeLabel.show()
	mistakes_this_shift -= 1


func _on_close_report_mouse_entered():
	%HoverSound.play()
