extends "res://scripts/Tile.gd"

export var exchanged_entity = "Heat"

var entity

var left_exists = false
var down_exists = false
var up_exists = false
var right_exists = false

var left_intake = 0.0
var down_intake = 0.0
var up_intake = 0.0
var right_intake = 0.0

var left_outlet = 0.0
var down_outlet = 0.0
var up_outlet = 0.0
var right_outlet = 0.0


var current_push = 0.0


func save():
	var save_dict = .save()
	save_dict["left_exists"] = left_exists
	save_dict["down_exists"] = down_exists
	save_dict["up_exists"] = up_exists
	save_dict["right_exists"] = right_exists
	save_dict["left_intake"] = left_intake
	save_dict["down_intake"] = down_intake
	save_dict["up_intake"] = up_intake
	save_dict["right_intake"] = right_intake
	save_dict["left_outlet"] = left_outlet
	save_dict["down_outlet"] = down_outlet
	save_dict["up_outlet"] = up_outlet
	save_dict["right_outlet"] = right_outlet
	save_dict["current_push"] = current_push


func after_load():
	.after_load()
	entity = .get_entity(exchanged_entity)


func _ready():
	._ready()
	entity = .get_entity(exchanged_entity)


func exist_to_false():
	left_exists = false
	down_exists = false
	up_exists = false
	right_exists = false


func neighbors_exists(tiles):
	exist_to_false()
	for tile in tiles:
		if x_indice > tile.x_indice:
			left_exists = tile.has_entity(exchanged_entity)
			if !left_exists:
				current_push -= left_outlet
				left_outlet = 0
		elif y_indice > tile.y_indice:
			down_exists = tile.has_entity(exchanged_entity)
			if !down_exists:
				current_push -= down_outlet
				down_outlet = 0
		elif y_indice < tile.y_indice:
			up_exists = tile.has_entity(exchanged_entity)
			if !up_exists:
				current_push -= up_outlet
				up_outlet = 0
		else:
			right_exists = tile.has_entity(exchanged_entity)
			if !right_exists:
				current_push -= right_outlet
				right_outlet = 0


func count_outlets():
	var outlets = 0
	if left_exists:
		outlets += 1
	if down_exists:
		outlets += 1
	if up_exists:
		outlets += 1
	if right_exists:
		outlets += 1
	return outlets


func zero_out():
	left_intake = 0.0
	down_intake = 0.0
	up_intake = 0.0
	right_intake = 0.0
	left_outlet = 0.0
	down_outlet = 0.0
	up_outlet = 0.0
	right_outlet = 0.0


func update_outlets(new_push, outlets):
	var divided_new_push = new_push / outlets
	left_outlet += (divided_new_push - left_outlet) / 2
	down_outlet += (divided_new_push - down_outlet) / 2
	up_outlet += (divided_new_push - up_outlet) / 2
	right_outlet += (divided_new_push - right_outlet) / 2


func tile_logic(tiles):
	neighbors_exists(tiles)
	var outlets = count_outlets()
	if outlets == 0:
		zero_out()
		return
	var new_push = current_push + (((entity.amount / 4) - current_push) / 2)
	update_outlets(new_push, outlets)
	for tile in tiles:
		if x_indice > tile.x_indice:
			if tile.has_entity(exchanged_entity):
				var tile_entity = tile.get_entity(exchanged_entity)
				left_intake += (((tile_entity.amount / 4) - left_intake) / 2)
		elif y_indice > tile.y_indice:
			if tile.has_entity(exchanged_entity):
				var tile_entity = tile.get_entity(exchanged_entity)
				down_intake += (((tile_entity.amount / 4) - down_intake) / 2)
		elif y_indice < tile.y_indice:
			if tile.has_entity(exchanged_entity):
				var tile_entity = tile.get_entity(exchanged_entity)
				up_intake += (((tile_entity.amount / 4) - up_intake) / 2)
		else:
			if tile.has_entity(exchanged_entity):
				var tile_entity = tile.get_entity(exchanged_entity)
				right_intake += (((tile_entity.amount / 4) - right_intake) / 2)
	.tile_logic(tiles)


func second_pass():
	print_debug("TODO")
	pass # TODO