extends TileMap

onready var global = get_node("/root/global")
export var collide_with_black = false
var shadow_tilemap = null

func _ready():
	if collide_with_black:	
		global.tilemap_collide_black = self
		shadow_tilemap = get_node("TileMap")
		shadow_tilemap.modulate = Color(0, 0, 0, 167.0/255.0)
		if shadow_tilemap != null:
			for cell in get_used_cells_by_id(3):
				shadow_tilemap.set_cell(cell.x, cell.y, get_shadow_tile_id(cell))
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

func set_cell_and_shadow(cell, id):
	set_cell(cell.x, cell.y, id)
	var cells = []
	cells.append(Vector2(cell.x - 1, cell.y))
	cells.append(Vector2(cell.x + 1, cell.y))
	cells.append(Vector2(cell.x, cell.y + 1))
	cells.append(Vector2(cell.x, cell.y - 1))
		
	if id == 3 and shadow_tilemap != null:
		shadow_tilemap.set_cell(cell.x, cell.y, get_shadow_tile_id(cell))
	elif id == 2 and shadow_tilemap != null:
		shadow_tilemap.set_cell(cell.x, cell.y, -1)
	
	for cell_shadow in cells:
		if get_cell(cell_shadow.x, cell_shadow.y) == 3: 
			shadow_tilemap.set_cell(cell_shadow.x, cell_shadow.y, get_shadow_tile_id(cell_shadow))
		
				
func get_shadow_tile_id(cell):
	var left = get_cell(cell.x - 1, cell.y)
	var right = get_cell(cell.x + 1, cell.y)
	var top = get_cell(cell.x, cell.y - 1)
	var bottom = get_cell(cell.x, cell.y + 1)
	
	if left == 2 or left == 5:
		if right == 2 or right == 5:
			if top == 2 or top == 5:
				if bottom == 2 or bottom == 5:
					return 14
				else:
					return 5
			elif bottom == 2 or bottom == 5:
				return 4
			else:
				return 2
		elif top == 2 or top == 5:
			if bottom == 2 or bottom == 5:
				return 3
			else:
				return 8
		elif bottom == 2 or bottom == 5:
			return 7
		else:
			return 10	
	elif right == 2 or right == 5:
		if top == 2 or top == 5:
			if bottom == 2 or bottom == 5:
				return 0
			else:
				return 9
		elif bottom == 2 or bottom == 5:
			return 6
		else:
			return 11
	elif top == 2 or top == 5:
		if bottom == 2 or bottom == 5:
			return 1
		else:
			return 13
	elif bottom == 2 or bottom == 5:
		return 12
	else:
		return -1