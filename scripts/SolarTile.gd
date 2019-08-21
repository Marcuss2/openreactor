extends "res://scripts/Tile.gd"

export var heat_gen = 4.0

func tile_logic(tiles):
	var heat_entities = .get_entities_from_tiles("Heat", tiles)
	for entity in heat_entities:
		if entity.amount + heat_gen / heat_entities.size() > entity.capacity:
			entity.amount = entity.capacity
		else:
			entity.amount += heat_gen / heat_entities.size()
	.tile_logic(tiles)


func save():
	var save_dict = .save()
	save_dict["heat_gen"] = heat_gen
	return save_dict


func get_hover_text():
	return hover_text + "\nHeat generation: " + str(heat_gen)