extends Area2D

signal clicked
signal exploded

export var id = 0
export var tile_entities = {}

var x_indice = 0
var y_indice = 0


func tile_logic(tiles):
	pass

func explode():
	emit_signal("exploded", x_indice, y_indice)

func _process(delta):
	for item in tile_entities.values():
		item.amount = item.old_amount
	if "heat" in tile_entities && tile_entities["heat"].capacity < tile_entities["heat"].amount:
		explode()


func init(pos_x, pos_y, x_indice, y_indice):
	position.x = pos_x
	position.y = pos_y
	self.x_indice = x_indice
	self.y_indice = y_indice

func has_entity_capacity(entity):
	return entity in tile_entities

func get_entity_capacity(entity):
	return tile_entities[entity].capacity

func _on_Tile_input_event(viewport, event, shape_idx):
	if event.is_pressed():
		emit_signal("clicked", x_indice, y_indice)
