extends CenterContainer

signal clicked

export var id = 0
export (Texture) var texture
export var selected = Color(0.7, 0.7, 1)
export var unavaiable = Color(0.7, 0.7, 0.7, 0.5)

var is_selected = false
var cost = 1.0


func _ready():
	$TextureRect2.texture = texture
	cost = Global.cost[id]
	tick()


func after_load():
	tick()


func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and !is_selected:
			emit_signal("clicked", id)
	if event is InputEventMouseMotion:
		get_tree().call_group("mouse_in", "remove_mouse_in")
		Global.hovered(id)


func reset_select(id):
	if id == self.id:
		is_selected = true
		tick()
	else:
		is_selected = false
		tick()


func tick():
	if cost > Global.money and is_selected:
		$TextureRect.modulate = selected.blend(unavaiable)
		$TextureRect2.modulate = selected.blend(unavaiable)
	elif cost > Global.money:
		$TextureRect.modulate = unavaiable
		$TextureRect2.modulate = unavaiable
	elif is_selected:
		$TextureRect.modulate = selected
		$TextureRect2.modulate = selected
	else:
		$TextureRect.modulate = Color(1, 1, 1)
		$TextureRect2.modulate = Color(1, 1, 1)