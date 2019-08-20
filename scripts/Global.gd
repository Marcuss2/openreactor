extends Node

export var cost = []
export var tile_resource = []
export var money = 3.0


var magnitudes = ["", "k", "M", "G", "T", "P", "E", "Z", "Y"]


func get_money_string():
	var mag = money
	var i = 0
	while mag > 10000:
		mag /= 1000
		i += 1
	return str(mag) + magnitudes[i]


func get_tile_instance(id):
	return tile_resource[id].instance()


func save_globals(save_game):
	var save_dict = {
		"money" : money
		}
	save_game.store_line(to_json(save_dict))


func save_game():
	var save_game = File.new()
	save_game.open_compressed("user://newsavegame.save", File.WRITE, File.COMPRESSION_ZSTD)
	save_globals(save_game)
	var save_nodes = get_tree().get_nodes_in_group("persist_1")
	for i in save_nodes:
		var node_data = i.call("save")
		save_game.store_line(to_json(node_data))
	save_nodes = get_tree().get_nodes_in_group("persist_2")
	for i in save_nodes:
		var node_data = i.call("save")
		save_game.store_line(to_json(node_data))
	save_nodes = get_tree().get_nodes_in_group("persist_3")
	for i in save_nodes:
		var node_data = i.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()
	var dir = Directory.new()
	if dir.file_exists("user://savegame.save"):
		dir.remove("user://savegame.save")
	dir.rename("user://newsavegame.save", "user://savegame.save")


func load_globals(current_line):
	money = current_line["money"]


func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return false
	var save_nodes = get_tree().get_nodes_in_group("persist_1")
	for i in save_nodes:
		i.name = "queued"
		i.queue_free()
	var entities_deleted = false
	save_game.open_compressed("user://savegame.save", File.READ, File.COMPRESSION_ZSTD)

	while not save_game.eof_reached():
		var line = save_game.get_line()
		if validate_json(line):
			continue
		var current_line = parse_json(line)
		if current_line.has("money"):
			load_globals(current_line)
			continue
		if !entities_deleted and current_line["filename"] == "res://scenes/Entity.tscn":
			for entity in get_tree().get_nodes_in_group("persist_3"):
				entity.set_name("queued")
				entity.queue_free()
				entities_deleted = true
		var new_object = load(current_line["filename"]).instance()
		var parent = get_node(current_line["parent"])
		get_node(current_line["parent"]).add_child(new_object)
		new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
		if current_line.has("tint_progress_r"):
			new_object.tint_progress = Color(current_line["tint_progress_r"], current_line["tint_progress_g"], current_line["tint_progress_b"], current_line["tint_progress_a"])
		for i in current_line.keys():
#			if i == "filename" or i == "parent" or i == "tint_progress_r" or i == "tint_progress_g" or i == "tint_progress_b" or i == "tint_progress_a" or i == "pos_x" or i == "pos_y":
			if i in ["filename", "parent", "tint_progress_r", "tint_progress_g", "tint_progress_b", "tint_progress_a", "pos_x", "pos_y"]:
				continue
			new_object.set(i, current_line[i])
	save_game.close()
	for node in get_tree().get_nodes_in_group("persist_1"):
		node.after_load()
	for node in get_tree().get_nodes_in_group("persist_2"):
		node.after_load()
	for node in get_tree().get_nodes_in_group("persist_3"):
		node.after_load()
	return true