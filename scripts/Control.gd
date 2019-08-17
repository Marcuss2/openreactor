extends Control

signal tile_select


func _on_Settings_Button_pressed():
	print("Settings button pressed")


func _on_Tile_Button_pressed(tile_id):
	print_debug("Tile id: " + str(tile_id) + " selected")
	get_tree().call_group("tile_buttons", "reset_select", tile_id)
	emit_signal("tile_select", tile_id)
