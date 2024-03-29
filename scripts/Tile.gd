extends Area2D

signal clicked
signal exploded
signal clear

export var id = 0
export var upgrade_id = 0
export var cost = 0.0
var tile_entities = {}
var enabled = true

enum TileType {EMPTY, REACTOR, EXCHANGER_HEAT, GENERATOR, BOOSTER, OTHER}

export (TileType) var type

var x_indice = 0
var y_indice = 0

var mouse_in = false

export var hover_text = "An empty tile"

func tile_logic(tiles):
	if mouse_in:
		Global.set_text_hover_label(get_hover_text())

func get_hover_text():
	return hover_text


func _ready():
	tile_entities = {}
	for entity in $AnimatedSprite/Bars.get_children():
		tile_entities[entity.name] = entity
		entity.connect("critical_over_capacity", self, "explode")
		entity.connect("critial_under_capacity", self, "ran_out")


func apply_upgrade(upgrades):
	pass


func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"name" : name,
		"id" : id,
		"upgrade_id" : upgrade_id,
		"cost" : cost,
		"enabled" : enabled,
		"pos_x" : position.x,
		"pos_y" : position.y,
		"x_indice" : x_indice,
		"y_indice" : y_indice
		}
	return save_dict


func after_load():
	_ready()


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


func ran_out():
	enabled = false


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
			print_debug("tile clicked")
			emit_signal("clicked", x_indice, y_indice)
		if event.button_index == BUTTON_RIGHT and event.pressed:
			Global.money += get_sell_cost()
			emit_signal("clear", x_indice, y_indice)


func remove_mouse_in():
	mouse_in = false
	remove_from_group("mouse_in")


func set_enabled(enabled):
	self.enabled = enabled


func get_enabled():
	return enabled


func _on_Tile_mouse_entered():
	get_tree().call_group("mouse_in", "remove_mouse_in")
	add_to_group("mouse_in")
	mouse_in = true
	Global.set_text_hover_label(get_hover_text())
