extends KinematicBody2D

const SPEED = 30
const PATROLLING = 'PATROLLING'
const IDLING = 'IDLING'
const TARGETING = 'TARGETING'
const FLAMING = 'FLAMING'
var _world



var walk_animation_tick = 0
var _player
var is_patrolling = true
var velocity = Vector2()
var flip = false
var moving_direction = 1
var change_patrolling_direction_tick = 180
var current_patrolling_tick = 180
var walk = 0
var is_idling = false
var current_idling_tick = 180
var max_idling_tick = 720
var walking_animation_tick = 0
var animation 
var frame
var is_targeting = false
var target_x
var target_y
var max_hp = 1000
var hp = 1000
var current_state = PATROLLING
var looking_vector = Vector2(1, 0)
var secondary_state
var Explostion = preload("res://FX/Explosion.tscn")

var current_flaming_tick = 0
var max_flaming_tick = 15



var AlienShotSFX0 = load("res://FX//AlienShotSFX0.tscn")
var shot_sound
var blood_particles = load("res://FX/AlienBloodVFX.tscn").instance()

onready var _vision_area = get_node("VisionArea")
onready var _animation = get_node("AnimatedSprite")
onready var _left_floor_ray_cast = get_node("RayCast2DLeftFloor")
onready var _left_walls_ray_cast = get_node("RayCast2DLeftWalls")
onready var _right_walls_ray_cast = get_node("RayCast2DRightWalls")
onready var _right_floor_ray_cast = get_node("RayCast2DRightFloor")
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var _left_muzzle = get_node("LeftMuzzle")
onready var _right_muzzle = get_node("RightMuzzle")

var new_fire = load("res://Projectiles/FlamethrowerFireNew.tscn").instance()
var AlienProjectileGreen = load("res://Projectiles/AlienProjectileGreen.tscn")
var fire

func flame():
	if _world:
		
		
		if not new_fire.is_casting:
			new_fire.is_casting = true
		
		
func _ready():
	_world = get_parent()
	add_to_group("Enemies")
	_world.add_child(new_fire)
	
		
func _physics_process(delta):
	if _player != null:
		if abs(_player.position.x - position.x) > 2000:
			return
			
	if looking_vector == Vector2(-1, 0):
		new_fire.global_position = _left_muzzle.global_position
			
	else:
		new_fire.global_position = _right_muzzle.global_position
			
	current_flaming_tick -= 1
	
	walk_animation_tick += 2
	if walk_animation_tick >= 70:
		walk_animation_tick = 0
	
	if current_state != TARGETING:
		secondary_state = null
	
	if secondary_state == FLAMING:
		if current_flaming_tick <= 0:
			current_flaming_tick = max_flaming_tick
			flame()
			
			

	if secondary_state == null and new_fire.is_casting:
		new_fire.is_casting = 0
	
	
	
	
	_world = get_parent()
	_player = _world.get_node("Player")
	
	if _player != null:
		if _vision_area.overlaps_body(_player):
			if _player.position.x > position.x:
				if _right_walls_ray_cast.is_colliding():
					if _right_walls_ray_cast.get_collision_point().x > _player.position.x:
						current_state = TARGETING
				else:
					current_state = TARGETING
			else:
				if _left_walls_ray_cast.is_colliding():
					if _left_walls_ray_cast.get_collision_point().x < _player.position.x:
						current_state = TARGETING
				else:
					current_state = TARGETING
		else:	
			
			current_state = PATROLLING
			
	
	if current_state == TARGETING:
		secondary_state = FLAMING
		if abs(position.x - _player.position.x)  >= 5:
			if _player.position.x > position.x:
					moving_direction = 1
					looking_vector = Vector2(1, 0)
			else:
				moving_direction = -1
				looking_vector = Vector2(-1, 0)
		
			
		
		else:
			current_state = IDLING
			current_idling_tick = max_idling_tick
	
				
	if current_state == PATROLLING:
		if current_patrolling_tick <= 0:
			moving_direction *= -1
			looking_vector *= -1
			current_patrolling_tick = change_patrolling_direction_tick
		if moving_direction == 1:
			if not _right_floor_ray_cast.is_colliding() and is_on_floor():
				moving_direction *= -1
				looking_vector *= -1
				current_patrolling_tick = change_patrolling_direction_tick
				current_state = IDLING
				current_idling_tick = max_idling_tick
		elif moving_direction == -1:
			if not _left_floor_ray_cast.is_colliding() and is_on_floor():
				moving_direction *= -1
				looking_vector *= -1
				current_patrolling_tick = change_patrolling_direction_tick
				current_state = IDLING
				current_idling_tick = max_idling_tick
		if randi() % 200 == 0:
			current_state = IDLING
			current_idling_tick = max_idling_tick
		current_patrolling_tick -= 1
		
		
	
	walk = SPEED * moving_direction
	
	if current_state == IDLING:
		current_idling_tick -= 1
		if current_idling_tick <= 0:
			current_state = PATROLLING
		walk = 0

	velocity.x = walk



	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	
	if moving_direction < 0:
		flip = false
	if moving_direction > 0:
		flip = true
	
	if velocity.x != 0:
		animation = "walk"
	else:
		animation = "idle"
	
	if secondary_state == FLAMING:
		animation += "_attacking"
	
	frame = walk_animation_tick / 10
	
	_animation.animation = animation
	
	if flip:
		_animation.flip_h = true
	else:
		_animation.flip_h = false
	
	_animation.play()
	
	
		
func take_damage(damage):
	hp -= damage
	if hp <= 0:
		if _world:
			var explosion = Explostion.instance()
			_world.add_child(explosion)
			explosion.global_position = global_position
			new_fire.queue_free()
		queue_free()
		

		
	
