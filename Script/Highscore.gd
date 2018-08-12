extends Node2D

onready var global = get_node("/root/global")

func _ready():
	$Skip2.text = str(global.nb_skip)
	
	var time = global.time
	var minute = floor(time / 60)
	var second = ceil(time - minute * 60)
	var text_second = str(second)
	if second < 10:
		text_second = "0" + text_second
	var text_minute = str(minute)
	if minute < 10:
		text_minute = "0" + text_minute
	$Time.text = text_minute + ":" + text_second
	
func _process(delta):
	$blacktowhite2.text = str(global.nb_white)
	$whitetoblack2.text = str(global.nb_black)
	$Collision2.text = str(global.nb_collision)
	$Restart2.text = str(global.nb_restart)