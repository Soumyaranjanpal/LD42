extends Node

var current_level = 0
var current_scene
var mouse
var hovered_objs = []
var camera
var player_black = null
var player_white = null

var tilemap_collide_black = null
var tilemap_collide_white = null
var end_taken_black = 0
var end_taken_white = 0

#stats
var nb_restart = 0
var time = 0
var nb_collision = 0
var nb_black = 0
var nb_white = 0
var nb_skip = 0

#levels
var levels = ['res://Levels/level100.tscn', 'res://Levels/level110.tscn', 'res://Levels/level120.tscn', 'res://Levels/level130.tscn', 'res://Levels/level140.tscn' \
			, 'res://Levels/level200.tscn', 'res://Levels/level210.tscn', 'res://Levels/level220.tscn', 'res://Levels/level225.tscn', 'res://Levels/level230.tscn' \
			, 'res://Levels/level300.tscn', 'res://Levels/level310.tscn', 'res://Levels/level320.tscn', 'res://Levels/level330.tscn', 'res://Levels/level340.tscn' \
			, 'res://Levels/level400.tscn', 'res://Levels/level410.tscn', 'res://Levels/level420.tscn', 'res://Levels/level430.tscn', 'res://Levels/endscreen.tscn' \
			, 'res://Levels/level500.tscn']

#functions
func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )

func _process(delta):
	time += delta
	if Input.is_action_just_pressed("restart"):
		nb_restart += 1
		call_deferred("_deferred_goto_scene", levels[current_level])
	elif Input.is_action_just_pressed("next_level"):
		nb_skip += 1
		next_scene()

func next_scene():
	current_level = current_level + 1
	if current_level >= len(levels):
		current_level = 0
	if current_level == 1:
		time = 0
		nb_white = 0
		nb_black = 0
		nb_collision = 0
		nb_skip = 0
		nb_restart = 0
	
	call_deferred("_deferred_goto_scene", levels[current_level])

func get_tilemap(collide_with_black):
	if collide_with_black:
		return tilemap_collide_black
	else:
		return tilemap_collide_white

func get_nb_end_taken(collide_with_black):
	if collide_with_black:
		return end_taken_black
	else:
		return end_taken_white

func _deferred_goto_scene(path):

    # Immediately free the current scene,
    # there is no risk here.
    current_scene.free()

    # Load new scene
    var s = ResourceLoader.load(path)

    # Instance the new scene
    current_scene = s.instance()

    # Add it to the active scene, as child of root
    get_tree().get_root().add_child(current_scene)

    # optional, to make it compatible with the SceneTree.change_scene() API
    get_tree().set_current_scene( current_scene )
    
    #post
    post_load_scene()

func get_level_nb():
	return (global.current_level % 5) + 1

func get_world_nb():
	return ceil((global.current_level + 1) / 5.0)

func post_load_scene():
	end_taken_white = 0
	end_taken_black = 0