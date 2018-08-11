extends Node2D

var exit_done = false
onready var player = preload("res://Script/Player.gd")
onready var global = get_node("/root/global")

export var black_player_end = false

var collected = false

func _ready():
	global.end_taken = 0
	if black_player_end:
		$ExitArea/Sprite.modulate = Color(100.0/255.0, 0, 211.0/255.0, 1.0);
	else:
		$ExitArea/Sprite.modulate = Color(200.0/255.0, 0, 211.0/255.0, 1.0);
		
func _on_ExitArea_body_entered(body):
	if body is player and body.collide_with_black == black_player_end:
		if collected:
			return
		global.end_taken += 1
		collected = true
		visible = false
		print("collected")
		
		if global.level_complete():
			if not exit_done:
				exit_done = true
				get_parent().get_parent().transition_out()
				get_parent().get_node("Timer").start()
				print("end")
		else:
			pass
			#get_node("/root/globalscene").get_node("TeleportSound").play()

func _on_Timer_timeout():
	get_node("/root/global").next_scene()