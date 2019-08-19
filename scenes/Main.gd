extends Node


func _ready():
	if !Global.load_game():
		$TileArea.init()
	$Control.connect("tile_select", $TileArea, "_on_Control_tile_select")


func _on_Timer_timeout():
	Global.save_game()
