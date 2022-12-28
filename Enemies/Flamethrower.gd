extends KinematicBody2D

const SPEED = 30
const PATROLLING = 'PATROLLING'
const IDLING = 'IDLING'
const TARGETING = 'TARGETING'
var _world

func _ready():
	_world = get_parent()
	add_to_group("Enemies")

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
var current_shoting_tick = 0
var max_shooting_tick = 80
var looking_vector = Vector2(1, 0)

var AlienShotSFX0 = load("res://FX//AlienShotSFX0.tscn")
var shot_sound
var blood_particles = load("res://FX/AlienBloodParticle.tscn").instance()

onready var _vision_area = get_node("VisionArea")
onready var _animation = get_node("AnimatedSprite")
onready var _left_floor_ray_cast = get_node("RayCast2DLeftFloor")
onready var _left_walls_ray_cast = get_node("RayCast2DLeftWalls")
onready var _right_walls_ray_cast = get_node("RayCast2DRightWalls")
onready var _right_floor_ray_cast = get_node("RayCast2DRightFloor")
onready var _right_platform_length_ray_cast = get_node("RayCast2DPlatformLengthRight")
onready var _left_platform_length_ray_cast = get_node("RayCast2DPlatformLengthLeft")
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var AlienProjectileGreen = load("res://Projectiles/AlienProjectileGreen.tscn")
var projectile


func shoot():
	if _world:
		shot_sound = AlienShotSFX0.instance()
		projectile = AlienProjectileGreen.instance()
		_world.add_child(projectile)
		_world.add_child(shot_sound)
		projectile.rotation = looking_vector.angle_to(Vector2.RIGHT)
		projectile.global_position = global_position
		shot_sound.global_position = global_position

func _physics_process(delta):
	if _player != null:
		if abs(_player.position.x - position.x) > 2000:
			return
	current_shoting_tick -= 1
	walk_animation_tick += 2
	if walk_animation_tick >= 70:
		walk_animation_tick = 0
	
	
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
		if current_shoting_tick <= 0:
			current_shoting_tick = max_shooting_tick
			
			shoot()
		if abs(position.x - _player.position.x)  >= 20:
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
			_world.add_child(blood_particles)
			blood_particles.global_position = global_position
			blood_particles.emitting = true
		queue_free()
		

		
		
