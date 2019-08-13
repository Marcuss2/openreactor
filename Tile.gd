extends Area2D

signal clicked

export var id = 0
export var heat_capacity = 0

var heat = 0
var oldheat = 0
var x_indice = 0
var y_indice = 0


func tile_logic(tiles):
	pass


func _process(delta):
	oldheat = heat


func init(pos_x, pos_y, x_indice, y_indice):
	position.x = pos_x
	position.y = pos_y
	self.x_indice = x_indice
	self.y_indice = y_indice

func has_heat_capacity():
	return heat_capacity != 0

func get_heat_capacity():
	return heat_capacity


func _on_Tile_input_event(viewport, event, shape_idx):
	if event.is_pressed():
		emit_signal("clicked", x_indice, y_indice)
