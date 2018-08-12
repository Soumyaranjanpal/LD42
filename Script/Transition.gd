extends Node

onready var global = get_node("/root/global")
onready var flux = get_node("/root/flux")
var wait_time = 1.5
var counter_world = 0

func _ready():
	$Camera2D/Transition.apply_scale($Camera2D.zoom)
	$Camera2D/Transition/LeftDoor.translate(Vector2(512* $Camera2D.zoom.x, 0))
	$Camera2D/Transition/RightDoor.translate(Vector2(-512* $Camera2D.zoom.x, 0))
	
	if global.get_level_nb() == 5:
		$ExitAreas/Timer.wait_time = wait_time + 1
	else:
		$ExitAreas/Timer.wait_time = wait_time + 0.5
		
	counter_world = global.get_world_nb()
	$Camera2D/Transition/LeftDoor/Counter.text = str(counter_world)
	$Camera2D/Transition/RightDoor/Counter.text = str(global.get_level_nb())
	
	transition_in()

func transition_in():
	flux.to($Camera2D/Transition/LeftDoor, 1, {x = -512 * $Camera2D.zoom.x}, "relative").ease("quad","in")
	flux.to($Camera2D/Transition/RightDoor, 1, {x = 512 * $Camera2D.zoom.x}, "relative").ease("quad","in")
	
func transition_out():
	flux.to($Camera2D/Transition/LeftDoor, wait_time, {x = 512 * $Camera2D.zoom.x}, "relative").ease("bounce","out")
	flux.to($Camera2D/Transition/RightDoor, wait_time, {x = -512 * $Camera2D.zoom.x}, "relative").ease("bounce","out")
	
	if global.get_level_nb() == 5:
		var f = flux.to($Camera2D/Transition/LeftDoor/Counter2, 1, {modulate_a = 1}, "absolute").ease("quad","in")
		f.oncomplete.append(funcref(self, "oncomplete_lvlnbui"))
	
	flux.to($Camera2D/Transition/RightDoor/Counter2, 1, {modulate_a = 1}, "absolute").ease("quad","in").oncomplete.append(funcref(self, "oncomplete_nextlvl"))
	
func oncomplete_lvlnbui():
	$Camera2D/Transition/LeftDoor/Counter.text = str(counter_world + 1)
	flux.to($Camera2D/Transition/LeftDoor/Counter2, 1, {modulate_a = 0.1}, "absolute").ease("quad","inout")
	
func oncomplete_nextlvl():
	$Camera2D/Transition/RightDoor/Counter.text = str((global.get_level_nb() % 5) + 1)
	flux.to($Camera2D/Transition/RightDoor/Counter2, 1, {modulate_a = 0.1}, "absolute").ease("quad","inout")