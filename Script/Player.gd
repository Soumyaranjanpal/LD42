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
var direction = 1

var gravity_dir = 1
var upside_down = false
var gravity_areas = []
var gravity_multiplier = 1
var prev_gravity_dir = 1
var paint_sounds = []

onready var flux = get_node("/root/flux")
onready var global = get_node("/root/global")

func _ready():
	global.player = weakref(self)
	paint_sounds = [$Paint1, $Paint2, $Paint3]

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

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
		linear_velx = move_and_slide(Vector2(linear_vel.x, -40 * gravity_dir), FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	else:
		linear_velx = move_and_slide(Vector2(linear_vel.x, 0), FLOOR_NORMAL, SLOPE_SLIDE_STOP)
		
	if is_on_wall():
		direction = -direction
		if global.camera.get_ref():
			global.nb_collision += 1
			global.camera.get_ref().shake(0.2, 15, 5)
		$HitSound.play()

	linear_vel = move_and_slide(Vector2(0, linear_vel.y), FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	linear_vel.x = linear_velx.x

	# Detect Floor
	if is_on_floor():
		if not on_floor and global.camera.get_ref():
			if onair_time > 0.3:
				$FallSound.play()
				global.nb_collision += 1
				global.camera.get_ref().shake(0.2, 15, onair_time * 5)
		onair_time = 0		
		
	if is_on_ceiling():
		if not on_floor and global.camera.get_ref():
			if onair_time > 0.3:
				$FallSound.play()
				global.nb_collision += 1
				global.camera.get_ref().shake(0.2, 15, onair_time * 5)
		onair_time = 0


	on_floor = onair_time < MIN_ONAIR_TIME
	
	if prev_gravity_dir != gravity_dir:
		flux.to(self, 1, {gravity_multiplier = gravity_dir}, "absolute").ease('linear','out')
		prev_gravity_dir = gravity_dir

	### CONTROL ###

	# Horizontal Movement
	var target_speed = direction

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)	
	