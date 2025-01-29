class_name Cargo
extends Node2D
## Cargo crates stack

@export var default_variant: Texture2D
@export var variants : Array[Texture2D]

var quantity: int:
	set(value):
		quantity = clampi(value, types.size(), crates.get_child_count())
		update_crates()
var types: Array[int] = []
@onready var crates : Node2D = $Node2D


## Changes type of crates allowed to spawn. Guaranteed to spawn one of each type
func set_types(array: Array):
	types.assign(array)
	if quantity < types.size():
		quantity = types.size()
	update_crates_type()


func type_count():
	return variants.size()


func get_types_list() -> Array[int]:
	var array : Array[int]
	array.assign(range(type_count()))
	return array


func random_type() -> int:
	return randi_range(0, type_count() - 1)


func random_types(number: int) -> Array[int]:
	var array : Array[int]
	array.assign(range(type_count()))
	while array.size() > number:
		array.remove_at(randi_range(0, array.size() - 1))
	return array


## Returns maximum number of crates this stack can display
func get_max() -> int:
	return crates.get_child_count()


## Normally distributes the size of this cargo stack
func randomify():
	var mean = get_max()/2.0
	var dev = get_max()/3.0
	quantity = roundi(randfn(mean, dev))


## Normally distributes the size of this cargo stack biased towards more crates
func randomify_large():
	var mean = get_max()/2.0
	var dev = get_max()/3.0
	quantity = roundi(randfn(mean + dev, dev))


## Normally distributes the size of this cargo stack biased towards less crates
func randomify_small():
	var mean = get_max()/2.0
	var dev = get_max()/3.0
	quantity = roundi(randfn(mean - dev, dev))


## Updates individual crate visibility
func update_crates():
	for bi in range(crates.get_child_count()):
		if bi >= quantity:
			crates.get_child(bi).hide()
		else:
			crates.get_child(bi).show()
	update_crates_type()


## Updates individual crate type
func update_crates_type():
	if not types.is_empty():
		for bi in range(quantity):
			if bi < types.size():
				crates.get_child(bi).texture = variants[types[bi]]
			else:
				crates.get_child(bi).texture = variants[types.pick_random()]
