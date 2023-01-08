extends Area2D

var damage_dealt = false
onready var _animation = get_node("AnimatedSprite")
onready var _shake_area = get_node("ShakeArea")
onready var _sound = get_node("ExplosionSound")
var frame = 0
var animation_tick = 0
var is_sound_played = false

func _physics_process(delta):
	if not is_sound_played:
		_sound.play()
		is_sound_played = true
	
	_animation.set_frame(frame)
	animation_tick += 1.5
	if animation_tick == 120:
		queue_free()
	frame = animation_tick / 10
	
	
	
func _on_ShakeArea_player_entered(player):
	if player._camera.trauma <= 0.6:
		player._camera.add_trauma(0.5)
