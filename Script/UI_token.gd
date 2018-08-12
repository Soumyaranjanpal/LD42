extends Node2D

var nb = 0
var nb_white = 0
var nb_black = 0

var exitarea = load("res://Scene/ExitArea.tscn")
onready var flux = get_node("/root/flux")
onready var global = get_node("/root/global")

func _ready():
	var level_nb = global.get_level_nb()
	if level_nb == 1:
		get_node("/root/globalscene").reset(global.get_world_nb())
	elif level_nb >= 2:
		get_node("/root/globalscene").activate_next(global.get_world_nb(), level_nb)

func _process(delta):
	var nb_tokens = global.end_taken_black + global.end_taken_white
	if nb_tokens > nb:
		nb = nb_tokens
		add_token(nb_white == global.end_taken_white)
		
func add_token(black):
	var node = exitarea.instance()
	if black:
		nb_black += 1
		node.set_name("ui_black_" + str(nb_black))
		node.black_player_end = true
		node.number_id = nb_black
	else:
		nb_white += 1
		node.set_name("ui_white_" + str(nb_white))
		node.black_player_end = false
		node.number_id = nb_white
	node.scale = Vector2(0, 0)
	add_child(node)
	node.translate(Vector2((nb - 1) * -64, 0))
	node.in_init = true
	node.modulate.a = 0
	
	flux.to(node, 0.6, {scale_x = 0.6, scale_y = 0.6}, "absolute").ease("back","in").oncomplete.append(funcref(node, "init_done"))
	flux.to(node, 0.6, {modulate_a = 1}, "absolute").ease("back","in")