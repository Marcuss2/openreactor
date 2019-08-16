extends Control

signal tile_select

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Settings_Button_pressed():
	print("Settings button pressed")


func _on_Tile_Button_pressed(tile_id):
	print_debug("Tile id: " + str(tile_id) + " selected")
	emit_signal("tile_select", tile_id)
