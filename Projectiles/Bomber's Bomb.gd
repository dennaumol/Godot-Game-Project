extends KinematicBody2D

var velocity = Vector2()
var dropped = false
var living_tick = 60
var speed = 24
var Explostion = preload("res://FX/Explosion.tscn")
onready var _world = get_parent()

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var _blast_area = get_node("BlastArea")
onready var _animated_sprite = get_node("AnimatedSprite")




func _ready():
	_animated_sprite.animation = "default"

func _physics_process(delta):
	if dropped:
		_animated_sprite.animation = "falling"
		velocity.y += gravity * delta
		living_tick -= 1
		
		if is_on_floor() or living_tick <= 0:
			velocity.y = 0
			for body in _blast_area.get_overlapping_bodies():
				if body.is_in_group("Player") or body.is_in_group("Enemies"):
					body.take_damage(100)
			if _world != null:
				var explosion = Explostion.instance()
				_world.add_child(explosion)
				explosion.position = position
			queue_free()
		move_and_slide(velocity, Vector2.UP)
	

