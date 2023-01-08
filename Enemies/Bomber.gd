extends KinematicBody2D


func _ready():
	_world = get_parent()
	add_to_group("Enemies")

const PATROLLING = 'PATROLLING'
const IDLING = 'IDLING'
const TARGETING = 'TARGETING'
const RELOADING = 'RELOADING'
const DROPPING = "DROPPING"
const LOADING_BOMB = "LOADING BOMB"
const READY_TO_DROP = "READY TO DROP"
const SHOT_DOWN = 'SHOT_DOWN'
var Explostion = preload("res://FX/Explosion.tscn")
var flying_animation_tick = 0
var _player
var _world
var SPEED = 250
var SPEED_Y = 100
var velocity = Vector2()
var moving_direction_x = 1
var moving_direction_y = 1
var change_patrolling_direction_tick = 180
var current_patrolling_tick = 180
var move_x = 0
var move_y = 0
var current_idling_tick = 180
var max_idling_tick = 200
var animation 
var frame
var is_targeting = false
var target_x
var target_y
var max_hp = 400
var hp = 400
var shot_down = false
var current_state = PATROLLING
var max_current_flying_away_tick = 60
var current_flying_away_tick
var Bomb = preload("res://Projectiles/Bomber's Bomb.tscn")
var bomb
var secondary_state
var bomb_spawned = false
var current_bomb_loading_tick = 3
var max_bomb_loading_tick = 3
var max_reloading_tick = 45
var current_reloading_tick = 45
var is_needed_to_update = false
var _parent

onready var _floor_ray_cast = get_node("RayCast2DFloor")
onready var _vision_area = get_node("VisionArea")
onready var _animation = get_node("AnimatedSprite")
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if _player != null:
		if abs(_player.position.x - position.x) > 2000:
			return
	move_x = 0
	move_y = 0
	
	flying_animation_tick += 0.40
	if flying_animation_tick >= 3:
		flying_animation_tick = 0
	
	_player = _world.get_node("Player")
	
	if current_state != RELOADING:
		if _player != null:
			if _vision_area.overlaps_body(_player):
				current_state = TARGETING
			else:
				current_state = PATROLLING
				
		else:
			current_state = PATROLLING
	
	if current_state == TARGETING:
		
		if secondary_state != DROPPING and secondary_state != READY_TO_DROP:
			secondary_state = LOADING_BOMB
			
		if abs(_player.position.x - position.x) > 5:
			if _player.position.x > position.x:
				moving_direction_x = 1
			if _player.position.x < position.x:
				moving_direction_x = -1
		else:
			position.x = _player.position.x
			if secondary_state == READY_TO_DROP and abs(_player.position.y - position.y) <= 150:
				if _floor_ray_cast.is_colliding():
					if _floor_ray_cast.get_collision_point().y > _player.global_position.y:
						secondary_state = DROPPING
			moving_direction_x = 0
		move_x = SPEED * moving_direction_x
		if abs(_player.position.y - position.y) >= 150:
			moving_direction_y = 1
		elif abs(_player.position.y - position.y) <= 130:
			moving_direction_y = -1
		else:
			moving_direction_y = 0
		move_y = SPEED_Y * moving_direction_y
		
		
	if current_state == PATROLLING:
		move_x = SPEED * moving_direction_x
		current_patrolling_tick -= 1
		if randi() % 200 == 0:
			current_state = IDLING
			current_idling_tick = max_idling_tick
		if current_patrolling_tick <= 0:
			moving_direction_x *= -1
			current_patrolling_tick = change_patrolling_direction_tick
			
	if current_state == IDLING:
		current_idling_tick -= 1
		move_x = 0
		move_y = 0
		if current_idling_tick <= 0:
			current_state = PATROLLING
			current_patrolling_tick = change_patrolling_direction_tick
			
	if current_state == RELOADING:
		secondary_state = null
		moving_direction_y = -1
		move_y = SPEED_Y * moving_direction_y
		current_reloading_tick -= 1
		if current_reloading_tick <= 0:
			current_reloading_tick = max_reloading_tick
			current_state = PATROLLING
	

	velocity.x = move_x
	velocity.y = move_y

	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	if bomb:
		bomb.global_position = Vector2(global_position.x, global_position.y + 22)
		
	if secondary_state == LOADING_BOMB:
		if not bomb_spawned:
			bomb = Bomb.instance()
			bomb_spawned = true
			
		else:
			current_bomb_loading_tick -= 1
			if current_bomb_loading_tick <= 0:
				_world.add_child(bomb)
				bomb.global_position = Vector2(global_position.x, global_position.y + 22)
				secondary_state = READY_TO_DROP
				current_bomb_loading_tick = max_bomb_loading_tick
	
	if secondary_state == DROPPING:
		bomb.dropped = true
		bomb = null
		bomb_spawned = false
		secondary_state = null
		current_state = RELOADING

	
	if secondary_state == DROPPING or current_state == RELOADING:
		animation = "drop"
	else:
		animation = "default"
	

	frame = flying_animation_tick / 1
	
	_animation.animation = animation
	
	
	_animation.set_frame(frame)
	
	
func take_damage(damage):
	
	hp -= damage
	if hp <= 0:
		if bomb:
			bomb.dropped = true
		var explosion = Explostion.instance()
		_world.add_child(explosion)
		explosion.global_position = global_position
		queue_free()


