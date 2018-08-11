extends Node

var current_level = 0
var current_scene
var mouse
var hovered_objs = []
var camera
var player = null

var tilemap_collide_black = null
var tilemap_collide_white = null
var end_taken = 0

#stats
var nb_restart = 0
var time = 0
var nb_collision = 0

#levels
var levels = ['res://Levels/Level1.tscn', \
			'res://Levels/Level11.tscn', \
			'res://Levels/Level12.tscn']

var levels_names = [ '', \
			'1.0', \
			'']
			
var levels_end_takens = [1, 1, 2]

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
		next_scene()

func get_level_name():
	return levels_names[current_level]

func level_complete():
	return end_taken == levels_end_takens[current_level]

func next_scene():
	current_level = current_level + 1
	if current_level >= len(levels):
		current_level = 0
	if current_level == 1:
		time = 0
	
	call_deferred("_deferred_goto_scene", levels[current_level])

func get_tilemap(collide_with_black):
	if collide_with_black:
		return tilemap_collide_black
	else:
		return tilemap_collide_white
	
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