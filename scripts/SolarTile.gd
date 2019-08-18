extends "res://scripts/Tile.gd"

export (int) var heat_gen = 4.0

func tile_logic(tiles):
	var heat_entities = .get_entities_from_tiles("Heat", tiles)
	for entity in heat_entities:
		if entity.amount + heat_gen / heat_entities.size() > entity.capacity:
			entity.amount = entity.capacity
		else:
			entity.amount += heat_gen / heat_entities.size()
	
	.tile_logic(tiles)