extends CenterContainer

signal clicked

export var id = 0
export (Texture) var texture
export var selected = Color(0.5, 0.5, 1)
export var unavaiable = Color(1, 1, 1, 0.5)

var is_selected = false
var cost = 1.0

func _ready():
	$TextureRect.texture = texture
	cost = Global.cost[id]

func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and !is_selected:
			emit_signal("clicked", id)


func reset_select(id):
	if id == self.id:
		is_selected = true
	else:
		is_selected = false


func _process(delta):
	if cost > Global.money and is_selected:
		$TextureRect.modulate = selected.blend(unavaiable)
	elif cost > Global.money:
		$TextureRect.modulate = unavaiable
	elif is_selected:
		$TextureRect.modulate = selected
	else:
		$TextureRect.modulate = Color(1, 1, 1)