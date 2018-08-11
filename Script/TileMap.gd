extends TileMap

onready var global = get_node("/root/global")
export var collide_with_black = false

func _ready():
	if collide_with_black:	
		global.tilemap_collide_black = self
	else:
		set_collision_layer_bit(1, true)
		set_collision_mask_bit(1, true)
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
		global.tilemap_collide_white = self
		
		var black_tilemap = get_parent().get_node("TileMapBlackCollide")
		for cell in black_tilemap.get_used_cells():
			if black_tilemap.get_cellv(cell) == 3: #no collision white to collision white
				set_cell(cell.x, cell.y, 1)	
			elif black_tilemap.get_cellv(cell) == 2: #collision black to no collision black
				set_cell(cell.x, cell.y, 4)
			else:
				set_cell(cell.x, cell.y, black_tilemap.get_cellv(cell))