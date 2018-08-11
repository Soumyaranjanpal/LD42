extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var FLOOR_NORMAL = Vector2(0, -1)
var SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
var WALK_SPEED = 150 # pixels/sec
var ANGLE_SPEED = 0.0005
var AIR_ANGLE_SPEED = 0.0001

var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var direction = 0
var jump_press_time = 0
var jump_press_duration = 0.8

var gravity_dir = 1
var upside_down = false
var gravity_areas = []
var gravity_multiplier = 1
var prev_gravity_dir = 1
var extents = Vector2()
var extents_list = []

var colliding_tiles = Dictionary()
var player_input_name = "P1"

export var collide_with_black = false

onready var flux = get_node("/root/flux")
onready var global = get_node("/root/global")

func _ready():
	global.player = weakref(self)
	if not collide_with_black:
		$Sprite.texture = load("res://Assets/tile.png")
		player_input_name = "P2"
		set_collision_layer_bit(1, true)
		set_collision_mask_bit(1, true)
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
	
	extents = $CollisionShape2D.get_shape().get_extents()
	extents_list.append(extents)
	extents_list.append(Vector2(0,0) - extents)
	extents_list.append(Vector2(extents.x, -extents.y))
	extents_list.append(Vector2(-extents.x, extents.y))

#func _process(delta):
#

func _physics_process(delta):
	#increment counters

	onair_time += delta

	### MOVEMENT ###

	# Apply Gravity
	var gravity = Vector2(0,0)
	for area in gravity_areas:
		gravity += area.get_gravity()
	linear_vel += delta * gravity * gravity_dir
	
	# Move and Slide
	var linear_velx
	if on_floor:
		linear_velx = move_and_slide(Vector2(linear_vel.x, 0), FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	else:
		linear_velx = move_and_slide(Vector2(linear_vel.x, 0), FLOOR_NORMAL, SLOPE_SLIDE_STOP)
		
	if is_on_wall():
		if global.camera.get_ref():
			global.nb_collision += 1
			global.camera.get_ref().shake(0.2, 15, 5)

	linear_vel = move_and_slide(Vector2(0, linear_vel.y), FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	linear_vel.x = linear_velx.x

	# Detect Floor
	if is_on_floor():
		if not on_floor and global.camera.get_ref():
			if onair_time > 0.3:
				global.nb_collision += 1
				global.camera.get_ref().shake(0.2, 15, onair_time * 5)
		onair_time = 0		
		
	if is_on_ceiling():
		if not on_floor and global.camera.get_ref():
			if onair_time > 0.3:
				global.nb_collision += 1
				global.camera.get_ref().shake(0.2, 15, onair_time * 5)
		onair_time = 0


	on_floor = onair_time < MIN_ONAIR_TIME
	
	if prev_gravity_dir != gravity_dir:
		flux.to(self, 1, {gravity_multiplier = gravity_dir}, "absolute").ease('linear','out')
		prev_gravity_dir = gravity_dir

	### CONTROL ###

	# Horizontal Movement
	if Input.is_action_pressed(player_input_name + '_left'):
		direction = -1
	elif Input.is_action_pressed(player_input_name + '_right'):
		direction = 1
	else:
		direction = 0
		
	var target_speed = direction

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)
	
	# Vectical Movement
	if is_on_floor():
		if Input.is_action_just_pressed(player_input_name + '_up'):
			linear_vel.y = -150
			jump_press_time = 0
	if not is_on_floor():
		if Input.is_action_pressed(player_input_name + '_up'):
			jump_press_time += delta
			if jump_press_time < jump_press_duration and linear_vel.y < 0:
				linear_vel.y += -25 * (1.0 - jump_press_time / jump_press_duration)
			else:
				jump_press_time = jump_press_duration
	
	# Post motion
	check_colliding_tiles()
	
func check_colliding_tiles():
	var tilemap = global.get_tilemap(collide_with_black)
	
	var origin = transform.get_origin()
	
	var corner_colliding_tiles = Dictionary()
	for vec_extents in extents_list:
		var tile = tilemap.world_to_map(origin + vec_extents)
		corner_colliding_tiles[tile] = true
	
	#check removed tiles
	var center_colliding_tiles = []
	for tile in colliding_tiles:
		if not corner_colliding_tiles.has(tile):
			inverse_tile(tilemap, tile)
		else:
			center_colliding_tiles.append(tile)
	
	var center_tile = tilemap.world_to_map(origin)
	if not center_colliding_tiles.has(center_tile):
		center_colliding_tiles.append(center_tile)
	colliding_tiles = center_colliding_tiles
	
func inverse_tile(tilemap, tile):
	var tilemap_black = global.get_tilemap(true)
	var tilemap_white = global.get_tilemap(false)
	
	var tile_id = tilemap.get_cell(tile.x, tile.y)
	if tile_id == 3: #white no collide (black tilemap)
		tilemap_black.set_cell(tile.x, tile.y, 2)
		tilemap_white.set_cell(tile.x, tile.y, 4)
	elif tile_id == 4: #black no collide (white tilemap)
		tilemap_black.set_cell(tile.x, tile.y, 3)
		tilemap_white.set_cell(tile.x, tile.y, 1)
	
	
