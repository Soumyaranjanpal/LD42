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