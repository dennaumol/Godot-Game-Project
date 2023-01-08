extends KinematicBody2D


var velocity = Vector2(0, 0)
var speed = 200
var move_x
var move_y
var _world
var _player
var current_state = PATROLLING
var moving_direction_x = 1
var moving_direction_y = 0
var change_patrolling_direction_tick = 180
var current_patrolling_tick = 180
var current_idling_tick = 200
var max_idling_tick = 200
var hp = 100
var max_shooting_tick = 30
var current_shooting_tick = 0
var is_in_walls = false
var projectile

var KulebyakProjectile = load("res://Projectiles/KulebyakProjectile.tscn")
var blood_vfx = load("res://FX/AlienBloodVFX.tscn").instance()


const PATROLLING = 'PATROLLING'
const IDLING = 'IDLING'
const TARGETING = 'TARGETING'


onready var _vision_area = get_node("VisionArea")
onready var _animation = get_node("AnimatedSprite")
onready var _check_obstacles = get_node("RayCast2D")


func _ready():
	_world = get_parent()
	add_to_group("Enemies")
	

func shoot():
	if _world:
		projectile = KulebyakProjectile.instance()
		_world.add_child(projectile)
		projectile.rotation = get_angle_to(_player.global_position)
		projectile.global_position = global_position

func _physics_process(delta):
	if _player != null:
		if abs(_player.position.x - position.x) > 2000:
			return
	
	move_x = 0
	move_y = 0
	
	if _world != null and _player == null:
		_player = _world.get_node("Player")
	
	
	if _player != null:
		if _vision_area.overlaps_body(_player):
			current_state = TARGETING

	if current_state == TARGETING:
		current_shooting_tick -= 1
		if current_shooting_tick <= 0:
			_check_obstacles.rotation = get_angle_to(_player.global_position + _player.velocity)
			if _check_obstacles.is_colliding():
				if global_position.distance_to(_check_obstacles.get_collision_point()) > global_position.distance_to(_player.global_position):
					shoot()
			else:
				shoot()
			current_shooting_tick = max_shooting_tick
		if abs(_player.position.x - position.x) > 60:
			if _player.position.x > position.x:
				moving_direction_x = 1
			if _player.position.x < position.x:
				moving_direction_x = -1
			move_x = speed * moving_direction_x
		else:
			move_x = 20 * moving_direction_x
		if abs(_player.position.y - position.y) > 100:
			if _player.position.y > position.y:
				moving_direction_y = 1
			if _player.position.y < position.y:
				moving_direction_y = -1
			move_y = speed * moving_direction_y
		else:
			move_y = 0
		
			
			
	if current_state == PATROLLING:
		move_x = speed * moving_direction_x
		current_patrolling_tick -= 1
		if randi() % 100 == 0:
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
				
			
		
	velocity.x = move_x
	velocity.y = move_y
	
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		if _world:
			_world.add_child(blood_vfx)
			blood_vfx.global_position = global_position
			blood_vfx.emitting = true
		queue_free()
