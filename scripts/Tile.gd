extends Area2D

signal clicked
signal exploded
signal clear

export var id = 0
export var cost = 0.0
var tile_entities = {}
var enabled = true

var x_indice = 0
var y_indice = 0

func _ready():
	for entity in $AnimatedSprite/Bars.get_children():
		tile_entities[entity.name] = entity


func tile_logic(tiles):
	pass


func _process(delta):
	if enabled:
		$AnimatedSprite.modulate = Color(1, 1, 1, 1)
	else:
		$AnimatedSprite.modulate = Color(1, 1, 1, 0.5)


func get_entities_from_tiles(entity, tiles):
	var entities = []
	for tile in tiles:
		if tile.has_entity(entity):
			entities.append(tile.get_entity(entity))
	return entities


func explode():
	emit_signal("exploded", x_indice, y_indice)


func init(pos_x, pos_y, x_indice, y_indice):
	position.x = pos_x
	position.y = pos_y
	self.x_indice = x_indice
	self.y_indice = y_indice
	Global.money -= cost


func has_entity(entity_name):
	return entity_name in tile_entities


func get_entity(entity_name):
	return tile_entities[entity_name]


func get_sell_cost():
	if has_entity("Heat"):
		var heat = get_entity("Heat")
		return cost - int(cost * ceil(float(heat.amount) / heat.capacity))
	return cost


func _on_Tile_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("clicked", x_indice, y_indice)
		if event.button_index == BUTTON_RIGHT and event.pressed:
			Global.money += get_sell_cost()
			emit_signal("clear", x_indice, y_indice)
