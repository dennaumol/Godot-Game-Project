extends Area2D

var damage_dealt = false
onready var _animation = get_node("AnimatedSprite")
onready var _shake_area = get_node("ShakeArea")
onready var _sound = get_node("ExplosionSound")
onready var _circle_blast = get_node("CircleBlastVFX")
var is_sound_played = false

func _physics_process(delta):
	
	if not is_sound_played:
		_sound.play()
		is_sound_played = true
	
	if not _sound.playing and not _circle_blast.emitting:
			queue_free()
	
func _ready():
	_circle_blast.emitting = true

	
func _on_ShakeArea_player_entered(player):
	player._camera.trauma = 0.5
