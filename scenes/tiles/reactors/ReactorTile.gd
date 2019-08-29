extends "res://scripts/Tile.gd"


export var heat_gen = 10.0
export var reactivity = 1.0

var relative_reactivity = 1.0


func after_load():
	$AnimatedSprite/Bars/Longetivity.connect("critical_under_capacity", self, "run_out")


func save():
	var save_dict = .save()
	save_dict["heat_gen"] = heat_gen
	return save_dict


func upgrade_heat_gen(multiplier):
	heat_gen *= multiplier


func tile_logic(tiles):
	relative_reactivity = reactivity
	for tile in tiles:
		if tile.type == TileType.REACTOR:
			relative_reactivity += tile.reactivity
	for tile in tiles:
		if tile.type == TileType.BOOSTER:
			relative_reactivity *= tile.reaction_multiplier
	var heat_entities = .get_entities_from_tiles("Heat", tiles)
	for entity in heat_entities:
		entity.amount += heat_gen * relative_reactivity
	$AnimatedSprite/Bars/Longetivity.amount -= relative_reactivity


func get_hover_text():
	return hover_text + "\nCost: %s Heat generation: %s" % [Global.get_magnified_string(cost), Global.get_magnified_string(heat_gen * relative_reactivity)]


func run_out():
	enabled = false