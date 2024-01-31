extends TileMap

signal on_tile_mouse_hover(is_on_tile: bool)

func _process(_delta):
	var tilepos : Vector2i = local_to_map(get_global_mouse_position())
	on_tile_mouse_hover.emit(get_cell_tile_data(0,tilepos) != null)
