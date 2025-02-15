extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.cheat_debugger.connect(_toggle)
	if not OS.is_debug_build():
		hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not visible: return
	$VBoxContainer/IsLiar.text = "IsLiar:%s" % GameData.is_liar
	$VBoxContainer/IsSmuggler.text = "IsSmuggler:%s" % GameData.is_smuggler
	$"VBoxContainer/IsFatty".text = "IsFatty:%s" % GameData.is_fatty
	$VBoxContainer/Shift.text = "Shift:%d" % GameData.shift
	$VBoxContainer/LiedProcessed.text = "L:%d(%d) S:%d(%d) F:%d(%d) P:%d(%d)" % [
		GameData.lied, GameData.get_liars_quota(), 
		GameData.smuggled, GameData.get_smugglers_quota(), 
		GameData.fattied, GameData.get_fatties_quota(), 
		GameData.processed, GameData.get_quota()]
	$VBoxContainer/Factions.text = "Factions:%s(%s)" % [GameData.ship_info.get("Factions", []), GameData.get_illegal_factions()]
	$VBoxContainer/Cargos.text = "Cargoes:%s(%s)" % [GameData.ship_info.get("CargoTypes", []), GameData.get_illegal_cargo()]


func _toggle():
	visible = not visible
