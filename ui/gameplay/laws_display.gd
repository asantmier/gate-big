extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.shift_started.connect(update_laws)


func update_laws():
	var criminals = GameData.get_illegal_factions()
	var contraband = GameData.get_illegal_cargo()
	%FactionsSection.visible = not criminals.is_empty()
	for i in %CriminalList.get_child_count():
		%CriminalList.get_child(i).visible = i in criminals
	%ContrabandSection.visible = not contraband.is_empty()
	for i in %ContrabandList.get_child_count():
		%ContrabandList.get_child(i).visible = i in contraband
	%BannedSectionTitle.visible = %ContrabandSection.visible or %FactionsSection.visible
	
	%LimitsSection.visible = GameData.allowed_fatty
	%passengerlimit.text = str(GameData.get_passenger_limit())
	%cargolimit.text = str(GameData.get_cargo_limit())
