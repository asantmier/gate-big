@tool
extends Node2D

@export var enabled := true:
	set(value):
		enabled = value
		queue_redraw()
@export var observed : Node2D:
	set(value):
		if observed:
			observed.child_order_changed.disconnect(queue_redraw)
		observed = value
		if observed:
			observed.child_order_changed.connect(queue_redraw)
		queue_redraw()


#func _ready():
	#if Engine.is_editor_hint():
		#observed.child_order_changed.connect(queue_redraw)


func _draw():
	if Engine.is_editor_hint() and enabled:
		if not observed:
			return
		var ctr = 0
		for box in observed.get_children():
			ctr += 1
			draw_string_outline(ThemeDB.fallback_font, box.position - Vector2(25, 0), str(ctr), HORIZONTAL_ALIGNMENT_CENTER, -1, 50, 5)
