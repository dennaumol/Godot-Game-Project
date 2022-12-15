extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

const WALK_FORCE = 1200
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 250

var velocity = Vector2()
var is_moving = false
var flip = false
var angle = 0
var run_animation_tick = 0
var animation

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
func _physics_process(delta):
	run_animation_tick += 2
	if run_animation_tick >= 80:
		run_animation_tick = 0
	
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	angle = rad2deg(get_angle_to(get_global_mouse_position()))
	
	if Input.is_action_pressed("move_left"):
		flip = true
	if Input.is_action_pressed("move_right"):
		flip = false
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		is_moving = false
		
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		is_moving = true
		velocity.x += walk * delta
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor() and Input.is_action_just_pressed("jump_up"):
		velocity.y = -JUMP_SPEED

	if flip:
		angle = 180 - angle
		$AnimatedSprite.flip_h = true
	else:
		if angle < 0:
			angle = 360 + angle
		$AnimatedSprite.flip_h = false
	
	var frame = run_animation_tick / 20
	
	if is_moving:
		if 0.0 <= angle and angle <= 7.5:
			 animation = "run_00"
		elif 7.5 <= angle and angle <= 15.0:
			animation = "run_01"
		elif 15.0 <= angle and angle <= 22.5:
			animation = "run_02"
		elif 22.5 <= angle and angle <= 30.0:
			animation = "run_03"
		elif 30.0 <= angle and angle <= 37.5:
			animation = "run_04"
		elif 37.5 <= angle and angle <= 45.0:
			animation = "run_05"
		elif 45.0 <= angle and angle <= 52.5:
			animation = "run_06"
		elif 52.5 <= angle and angle <= 60.0:
			animation = "run_07"
		elif 60.0 <= angle and angle <= 67.5:
			animation = "run_08"
		elif 67.5 <= angle and angle <= 75.0:
			animation = "run_09"
		elif 75.0 <= angle and angle <= 82.5:
			animation = "run_10"
		elif 82.5 <= angle and angle <= 90.0:
			animation = "run_11"
		elif 90.0 <= angle and angle <= 97.5:
			animation = "run_12"
		elif 97.5 <= angle and angle <= 105.0:
			animation = "run_13"
		elif 105.0 <= angle and angle <= 112.5:
			animation = "run_14"
		elif 112.5 <= angle and angle <= 120.0:
			animation = "run_15"
		elif 120.0 <= angle and angle <= 127.5:
			animation = "run_16"
		elif 127.5 <= angle and angle <= 135.0:
			animation = "run_17"
		elif 135.0 <= angle and angle <= 142.5:
			animation = "run_18"
		elif 142.5 <= angle and angle <= 150.0:
			animation = "run_19"
		elif 150.0 <= angle and angle <= 157.5:
			animation = "run_20"
		elif 157.5 <= angle and angle <= 165.0:
			animation = "run_21"
		elif 165.0 <= angle and angle <= 172.5:
			animation = "run_22"
		elif 172.5 <= angle and angle <= 180.0:
			animation = "run_23"
		elif 180.0 <= angle and angle <= 187.5:
			animation = "run_24"
		elif 187.5 <= angle and angle <= 195.0:
			animation = "run_25"
		elif 195.0 <= angle and angle <= 202.5:
			animation = "run_26"
		elif 202.5 <= angle and angle <= 210.0:
			animation = "run_27"
		elif 210.0 <= angle and angle <= 217.5:
			animation = "run_28"
		elif 217.5 <= angle and angle <= 225.0:
			animation = "run_29"
		elif 225.0 <= angle and angle <= 232.5:
			animation = "run_30"
		elif 232.5 <= angle and angle <= 240.0:
			animation = "run_31"
		elif 240.0 <= angle and angle <= 247.5:
			animation = "run_32"
		elif 247.5 <= angle and angle <= 255.0:
			animation = "run_33"
		elif 255.0 <= angle and angle <= 262.5:
			animation = "run_34"
		elif 262.5 <= angle and angle <= 270.0:
			animation = "run_35"
		elif 270.0 <= angle and angle <= 277.5:
			animation = "run_36"
		elif 277.5 <= angle and angle <= 285.0:
			animation = "run_37"
		elif 285.0 <= angle and angle <= 292.5:
			animation = "run_38"
		elif 292.5 <= angle and angle <= 300.0:
			animation = "run_39"
		elif 300.0 <= angle and angle <= 307.5:
			animation = "run_40"
		elif 307.5 <= angle and angle <= 315.0:
			animation = "run_41"
		elif 315.0 <= angle and angle <= 322.5:
			animation = "run_42"
		elif 322.5 <= angle and angle <= 330.0:
			animation = "run_43"
		elif 330.0 <= angle and angle <= 337.5:
			animation = "run_44"
		elif 337.5 <= angle and angle <= 345.0:
			animation = "run_45"
		elif 345.0 <= angle and angle <= 352.5:
			animation = "run_46"
		elif 352.5 <= angle and angle < 360.0:
			animation = "run_47"
	elif not is_moving:
		frame = 0
		if 0.0 <= angle and angle <= 7.5:
			 animation = "idle_00"
		elif 7.5 <= angle and angle <= 15.0:
			animation = "idle_01"
		elif 15.0 <= angle and angle <= 22.5:
			animation = "idle_02"
		elif 22.5 <= angle and angle <= 30.0:
			animation = "idle_03"
		elif 30.0 <= angle and angle <= 37.5:
			animation = "idle_04"
		elif 37.5 <= angle and angle <= 45.0:
			animation = "idle_05"
		elif 45.0 <= angle and angle <= 52.5:
			animation = "idle_06"
		elif 52.5 <= angle and angle <= 60.0:
			animation = "idle_07"
		elif 60.0 <= angle and angle <= 67.5:
			animation = "idle_08"
		elif 67.5 <= angle and angle <= 75.0:
			animation = "idle_09"
		elif 75.0 <= angle and angle <= 82.5:
			animation = "idle_10"
		elif 82.5 <= angle and angle <= 90.0:
			animation = "idle_11"
		elif 90.0 <= angle and angle <= 97.5:
			animation = "idle_12"
		elif 97.5 <= angle and angle <= 105.0:
			animation = "idle_13"
		elif 105.0 <= angle and angle <= 112.5:
			animation = "idle_14"
		elif 112.5 <= angle and angle <= 120.0:
			animation = "idle_15"
		elif 120.0 <= angle and angle <= 127.5:
			animation = "idle_16"
		elif 127.5 <= angle and angle <= 135.0:
			animation = "idle_17"
		elif 135.0 <= angle and angle <= 142.5:
			animation = "idle_18"
		elif 142.5 <= angle and angle <= 150.0:
			animation = "idle_19"
		elif 150.0 <= angle and angle <= 157.5:
			animation = "idle_20"
		elif 157.5 <= angle and angle <= 165.0:
			animation = "idle_21"
		elif 165.0 <= angle and angle <= 172.5:
			animation = "idle_22"
		elif 172.5 <= angle and angle <= 180.0:
			animation = "idle_23"
		elif 180.0 <= angle and angle <= 187.5:
			animation = "idle_24"
		elif 187.5 <= angle and angle <= 195.0:
			animation = "idle_25"
		elif 195.0 <= angle and angle <= 202.5:
			animation = "idle_26"
		elif 202.5 <= angle and angle <= 210.0:
			animation = "idle_27"
		elif 210.0 <= angle and angle <= 217.5:
			animation = "idle_28"
		elif 217.5 <= angle and angle <= 225.0:
			animation = "idle_29"
		elif 225.0 <= angle and angle <= 232.5:
			animation = "idle_30"
		elif 232.5 <= angle and angle <= 240.0:
			animation = "idle_31"
		elif 240.0 <= angle and angle <= 247.5:
			animation = "idle_32"
		elif 247.5 <= angle and angle <= 255.0:
			animation = "idle_33"
		elif 255.0 <= angle and angle <= 262.5:
			animation = "idle_34"
		elif 262.5 <= angle and angle <= 270.0:
			animation = "idle_35"
		elif 270.0 <= angle and angle <= 277.5:
			animation = "idle_36"
		elif 277.5 <= angle and angle <= 285.0:
			animation = "idle_37"
		elif 285.0 <= angle and angle <= 292.5:
			animation = "idle_38"
		elif 292.5 <= angle and angle <= 300.0:
			animation = "idle_39"
		elif 300.0 <= angle and angle <= 307.5:
			animation = "idle_40"
		elif 307.5 <= angle and angle <= 315.0:
			animation = "idle_41"
		elif 315.0 <= angle and angle <= 322.5:
			animation = "idle_42"
		elif 322.5 <= angle and angle <= 330.0:
			animation = "idle_43"
		elif 330.0 <= angle and angle <= 337.5:
			animation = "idle_44"
		elif 337.5 <= angle and angle <= 345.0:
			animation = "idle_45"
		elif 345.0 <= angle and angle <= 352.5:
			animation = "idle_46"
		elif 352.5 <= angle and angle < 360.0:
			animation = "idle_47"
	
	$AnimatedSprite.animation = animation
	$AnimatedSprite.set_frame(frame)

