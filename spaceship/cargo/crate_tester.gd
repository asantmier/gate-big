@tool
extends Node2D

@export var enabled := true:
	set(value):
		enabled = value
		if enabled:
			change_crates()
		else:
			show_all()

@export var observed : Node2D:
	set(value):
		if observed:
			observed.child_order_changed.disconnect(change_crates)
			show_all()
		observed = value
		if observed:
			observed.child_order_changed.connect(change_crates)
			crates_visible = clampi(crates_visible, 0, observed.get_child_count())
			change_crates()

@export_range(0, 50, 1, "or_greater") var crates_visible: int:
	set(value):
		if observed:
			crates_visible = clampi(value, 0, observed.get_child_count())
		else:
			crates_visible = value
		change_crates()


func change_crates():
	if enabled and observed:
		for bi in range(observed.get_child_count()):
			if bi >= crates_visible:
				observed.get_child(bi).hide()
			else:
				observed.get_child(bi).show()


func show_all():
	if observed:
		for bi in range(observed.get_child_count()):
			observed.get_child(bi).show()
