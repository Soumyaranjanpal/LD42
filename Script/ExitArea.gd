extends Node2D

var exit_done = false
onready var player = preload("res://Script/Player.gd")
onready var global = get_node("/root/global")

export var black_player_end = false
export var number_id = 1

export var collected = false
var time = 0
export var in_init = false

func _ready():
	$Label.text = str(number_id)
	if black_player_end:
		$ExitArea/Sprite.modulate = Color(100.0/255.0, 0, 211.0/255.0, 1.0);
	else:
		$ExitArea/Sprite.modulate = Color(200.0/255.0, 0, 211.0/255.0, 1.0);

func init_done():
	in_init = false

func _process(delta):
	time += delta
	
	if not collected and not in_init:
		scale.x = sin(time * 3) * 0.125 + 0.7
		scale.y = sin(time * 3) * 0.125 + 0.7
		
func _on_ExitArea_body_entered(body):
	if body is player and body.collide_with_black == black_player_end:
		if collected or (number_id - 1) != global.get_nb_end_taken(black_player_end):
			return
		$CollectBlack.pitch_scale = (global.get_nb_end_taken(true) + global.get_nb_end_taken(false) - 1) * 0.2 + 1
		$CollectBlack.play()
		if black_player_end:
			#$CollectBlack.play()
			global.end_taken_black += 1
		else:
			#$CollectWhite.play()
			global.end_taken_white += 1
		collected = true
		print("collected")
		flux.to(self, 0.4, {scale_x = 0, scale_y = 0}, "absolute").ease("back","in").oncomplete.append(funcref(self, "oncomplete_visibleoff"))
		flux.to(self, 0.4, {modulate_a = 0}, "absolute").ease("back","in")
		$ExitArea/Sprite/Particles2D.emitting = true
		#$ExitArea/Sprite/Particles2D.restart()
		
		if check_level_complete():
			if not exit_done:
				exit_done = true
				get_parent().get_parent().transition_out()
				get_parent().get_node("Timer").start()
				print("end")
		else:
			pass
			#get_node("/root/globalscene").get_node("TeleportSound").play()

func oncomplete_visibleoff():
	pass
	#visible = false

func check_level_complete():
	var complete = true;
	for child in get_parent().get_children():
		if child is get_script():
			complete = complete and child.collected
	return complete

func _on_Timer_timeout():
	get_node("/root/global").next_scene()