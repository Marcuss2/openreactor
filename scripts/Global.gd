extends Node


export var cost = []
export var tile_resource = []
export var money := 3.0


var upgrades = []


var magnitudes = ["", "k", "M", "G", "T", "P", "E", "Z", "Y"]


func hovered(id):
	var temporary_tile = tile_resource[id].instance()
	set_upgrades(temporary_tile)
	set_text_hover_label(temporary_tile.get_hover_text())
	temporary_tile.queue_free()


func set_upgrades(tile):
	Upgrades.apply_upgrade_to_tile(tile)
	return tile


func get_magnified_string(number):
	var i = 0
	while number > 10000:
		number /= 1000
		i += 1
	return ("%.1f" % number) + magnitudes[i]


func get_money_string():
	return get_magnified_string(money)


func get_tile_instance(id):
	var tile = tile_resource[id].instance()
	tile = set_upgrades(tile)
	return tile


func set_text_hover_label(text):
	get_tree().call_group("hover_label", "set_text", text)


func save_globals(save_game):
	var save_dict = {
		"money" : money
		}
	save_game.store_line(to_json(save_dict))


func save_serialization(save_game):
	save_globals(save_game)
	save_game.store_line(to_json(Upgrades.save()))
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
	save_nodes = get_tree().get_nodes_in_group("persist_update")
	for i in save_nodes:
		var node_data = i.call("save")
		save_game.store_line(to_json(node_data))


func save_game():
	var save_game = File.new()
	save_game.open_compressed("user://newsavegame.save", File.WRITE, File.COMPRESSION_ZSTD)
	save_serialization(save_game)
	save_game.close()
	var dir = Directory.new()
	if dir.file_exists("user://savegame.save"):
		dir.remove("user://savegame.save")
	dir.rename("user://newsavegame.save", "user://savegame.save")


func load_globals(current_line):
	money = current_line["money"]


func pre_load():
	var save_nodes = get_tree().get_nodes_in_group("persist_1")
	for i in save_nodes:
		i.name = "queued"
		i.queue_free()


func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return false
	pre_load()
	var entities_deleted = false
	save_game.open_compressed("user://savegame.save", File.READ, File.COMPRESSION_ZSTD)
	# Don't touch this unless you absolutely have to.
	while not save_game.eof_reached():
		var line = save_game.get_line()
		if validate_json(line):
			continue
		var current_line = parse_json(line)
		if current_line.has("money"):
			load_globals(current_line)
			continue
		elif current_line.has("path"):
			get_node(current_line["path"]).load_node(current_line)
			continue
		elif current_line.has("upgrades"):
			Upgrades.load_node(current_line)
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
			if i in ["filename", "parent", "tint_progress_r", "tint_progress_g", "tint_progress_b", "tint_progress_a", "pos_x", "pos_y"]:
				continue
			new_object.set(i, current_line[i])
			
	save_game.close()
	after_load()
	return true


func after_load():
	for node in get_tree().get_nodes_in_group("persist_1"):
		node.after_load()
	for node in get_tree().get_nodes_in_group("persist_2"):
		node.after_load()
	for node in get_tree().get_nodes_in_group("persist_3"):
		node.after_load()