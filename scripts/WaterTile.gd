extends "res://scripts/Tile.gd"

export var water_gen = 2

func tile_logic(tiles):
	var water_entities = .get_entities_from_tiles("Water", tiles)
	for entity in water_entities:
		if entity.amount + water_gen / water_entities.size() > entity.capacity:
			entity.amount = entity.capacity
		else:
			entity.amount += water_gen / water_entities.size()
	
	.tile_logic(tiles)