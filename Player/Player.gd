extends KinematicBody2D

func _ready():
	
	_world = get_parent()
	add_to_group("Player")
	

	


var BlueProjectile = preload("res://Projectiles/BlueProjectile.tscn")

const WALK_FORCE = 1300
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 250

var velocity = Vector2()
var is_moving = false
var flip = false
var angle = 0
var _world
var run_animation_tick = 0
var animation
var targeted_by_bomber = 0
var fire_rate = 7
var current_shooting_tick = 0
var current_extra_jumps = 1
var max_extra_jumps = 1
var rad_angle = 0
var hp = 400
var max_hp = 400
var animation_angle = "00"
var animation_type = "idle"
var frame = 0
onready var _animation = get_node("AnimatedSprite")
onready var _camera = get_node("Camera")



var BlasterShotSFX0 = load("res://FX//BlasterShotSFX0.tscn")
var BlueShotVFX = load("res://FX/BlueShotVFX.tscn")
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func shoot():
	if _world != null:
		var shot_sfx = BlasterShotSFX0.instance()
		var shot_vfx = BlueShotVFX.instance()
		var projectile = BlueProjectile.instance()
		_world.add_child(shot_sfx)
		_world.add_child(projectile)
		_world.add_child(shot_vfx)
		projectile.rotation = get_angle_to(get_global_mouse_position())
		projectile.global_position = global_position - Vector2(-cos(rad_angle) * 20,  -sin(rad_angle) * 15)
		shot_sfx.global_position = global_position
		shot_vfx.global_position = global_position - Vector2(-cos(rad_angle) * 20,  -sin(rad_angle) * 15)
		shot_vfx.direction = Vector2(cos(rad_angle) * 20,  sin(rad_angle) * 15).normalized()
		shot_vfx.emitting = true
		_camera.trauma = max(_camera.trauma, 0.25)
	
	
	
func _physics_process(delta):
	
	current_shooting_tick -= 1
	run_animation_tick += 2
	if run_animation_tick >= 80:
		run_animation_tick = 0
	
	
	rad_angle = get_angle_to(get_global_mouse_position())
	
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	angle = rad2deg(rad_angle)
	
	
	if Input.is_action_pressed("move_left"):
		flip = true
	if Input.is_action_pressed("move_right"):
		flip = false
	if abs(walk) < WALK_FORCE * 0.2:
		is_moving = false
		
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		is_moving = true
		velocity.x += walk * delta
		
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	velocity.y += gravity * delta

	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	
	if Input.is_action_pressed("shoot") and current_shooting_tick <= 0:
		current_shooting_tick = fire_rate
		shoot()	


	if is_on_floor():
		current_extra_jumps = max_extra_jumps
	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor() and Input.is_action_just_pressed("jump_up"):
		velocity.y = -JUMP_SPEED
	
	elif not is_on_floor() and Input.is_action_just_pressed("jump_up") and current_extra_jumps > 0:
		velocity.y = -JUMP_SPEED
		current_extra_jumps -= 1

	if flip:
		angle = 180 - angle
		$AnimatedSprite.flip_h = true
	else:
		if angle < 0:
			angle = 360 + angle
		$AnimatedSprite.flip_h = false
	
	
	
	
	if 0.0 <= angle and angle <= 7.5:
		 animation_angle = "00"
	elif 7.5 <= angle and angle <= 15.0:
		animation_angle = "01"
	elif 15.0 <= angle and angle <= 22.5:
		animation_angle = "02"
	elif 22.5 <= angle and angle <= 30.0:
		animation_angle = "03"
	elif 30.0 <= angle and angle <= 37.5:
		animation_angle = "04"
	elif 37.5 <= angle and angle <= 45.0:
		animation_angle = "05"
	elif 45.0 <= angle and angle <= 52.5:
		animation_angle = "06"
	elif 52.5 <= angle and angle <= 60.0:
		animation_angle = "07"
	elif 60.0 <= angle and angle <= 67.5:
		animation_angle = "08"
	elif 67.5 <= angle and angle <= 75.0:
		animation_angle = "09"
	elif 75.0 <= angle and angle <= 82.5:
		animation_angle = "10"
	elif 82.5 <= angle and angle <= 90.0:
		animation_angle = "11"
	elif 90.0 <= angle and angle <= 97.5:
		animation_angle = "12"
	elif 97.5 <= angle and angle <= 105.0:
		animation_angle = "13"
	elif 105.0 <= angle and angle <= 112.5:
		animation_angle = "14"
	elif 112.5 <= angle and angle <= 120.0:
		animation_angle = "15"
	elif 120.0 <= angle and angle <= 127.5:
		animation_angle = "16"
	elif 127.5 <= angle and angle <= 135.0:
		animation_angle = "17"
	elif 135.0 <= angle and angle <= 142.5:
		animation_angle = "18"
	elif 142.5 <= angle and angle <= 150.0:
		animation_angle = "19"
	elif 150.0 <= angle and angle <= 157.5:
		animation_angle = "20"
	elif 157.5 <= angle and angle <= 165.0:
		animation_angle = "21"
	elif 165.0 <= angle and angle <= 172.5:
		animation_angle = "22"
	elif 172.5 <= angle and angle <= 180.0:
		animation_angle = "23"
	elif 180.0 <= angle and angle <= 187.5:
		animation_angle = "24"
	elif 187.5 <= angle and angle <= 195.0:
		animation_angle = "25"
	elif 195.0 <= angle and angle <= 202.5:
		animation_angle = "26"
	elif 202.5 <= angle and angle <= 210.0:
		animation_angle = "27"
	elif 210.0 <= angle and angle <= 217.5:
		animation_angle = "28"
	elif 217.5 <= angle and angle <= 225.0:
		animation_angle = "29"
	elif 225.0 <= angle and angle <= 232.5:
		animation_angle = "30"
	elif 232.5 <= angle and angle <= 240.0:
		animation_angle = "31"
	elif 240.0 <= angle and angle <= 247.5:
		animation_angle = "32"
	elif 247.5 <= angle and angle <= 255.0:
		animation_angle = "33"
	elif 255.0 <= angle and angle <= 262.5:
		animation_angle = "34"
	elif 262.5 <= angle and angle <= 270.0:
		animation_angle = "35"
	elif 270.0 <= angle and angle <= 277.5:
		animation_angle = "36"
	elif 277.5 <= angle and angle <= 285.0:
		animation_angle = "37"
	elif 285.0 <= angle and angle <= 292.5:
		animation_angle = "38"
	elif 292.5 <= angle and angle <= 300.0:
		animation_angle = "39"
	elif 300.0 <= angle and angle <= 307.5:
		animation_angle = "40"
	elif 307.5 <= angle and angle <= 315.0:
		animation_angle = "41"
	elif 315.0 <= angle and angle <= 322.5:
		animation_angle = "42"
	elif 322.5 <= angle and angle <= 330.0:
		animation_angle = "43"
	elif 330.0 <= angle and angle <= 337.5:
		animation_angle = "44"
	elif 337.5 <= angle and angle <= 345.0:
		animation_angle = "45"
	elif 345.0 <= angle and angle <= 352.5:
		animation_angle = "46"
	elif 352.5 <= angle and angle < 360.0:
		animation_angle = "47"
		
	if is_moving and is_on_floor():
		animation_type = "run"
		frame = run_animation_tick / 20
	
	if not is_moving and is_on_floor():
		animation_type = "idle"
		frame = 0
		
	if not is_on_floor():
		animation_type = "run"
		if velocity.y > -5:
			frame = 2
		else:
			frame = 3
		
	animation = animation_type + "_" + animation_angle	
	_animation.animation = animation
	_animation.set_frame(frame)

func take_damage(damage):
	hp -= damage
	_camera.trauma = max(_camera.trauma, 0.65)


