extends Node2D

var exit_done = false
onready var player = preload("res://Script/Player.gd")
onready var global = get_node("/root/global")

export var black_player_end = false
export var number_id = 1

var collected = false

func _ready():
	$Label.text = str(number_id)
	if black_player_end:
		$ExitArea/Sprite.modulate = Color(100.0/255.0, 0, 211.0/255.0, 1.0);
	else:
		$ExitArea/Sprite.modulate = Color(200.0/255.0, 0, 211.0/255.0, 1.0);
		
func _on_ExitArea_body_entered(body):
	if body is player and body.collide_with_black == black_player_end:
		if collected or (number_id - 1) != global.get_nb_end_taken(black_player_end):
			return
		if black_player_end:
			global.end_taken_black += 1
		else:
			global.end_taken_white += 1
		collected = true
		visible = false
		print("collected")
		
		if check_level_complete():
			if not exit_done:
				exit_done = true
				get_parent().get_parent().transition_out()
				get_parent().get_node("Timer").start()
				print("end")
		else:
			pass
			#get_node("/root/globalscene").get_node("TeleportSound").play()

func check_level_complete():
	var complete = true;
	for child in get_parent().get_children():
		if child is get_script():
			complete = complete and child.collected
	return complete

func _on_Timer_timeout():
	get_node("/root/global").next_scene()