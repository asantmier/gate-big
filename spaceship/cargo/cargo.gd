class_name Cargo
extends Node2D
## Cargo crates

var quantity: int:
	set(value):
		quantity = clampi(value, 0, crates.get_child_count())
		update_crates()
@onready var crates : Node2D = $Node2D


func get_max() -> int:
	return crates.get_child_count()


func randomify():
	var mean = get_max()/2.0
	var dev = get_max()/3.0
	quantity = roundi(randfn(mean, dev))


func randomify_large():
	var mean = get_max()/2.0
	var dev = get_max()/3.0
	quantity = roundi(randfn(mean + dev, dev))


func randomify_small():
	var mean = get_max()/2.0
	var dev = get_max()/3.0
	quantity = roundi(randfn(mean - dev, dev))


func update_crates():
	for bi in range(crates.get_child_count()):
		if bi >= quantity:
			crates.get_child(bi).hide()
		else:
			crates.get_child(bi).show()
