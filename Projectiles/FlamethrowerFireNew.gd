extends RayCast2D

var cast_point
var is_casting := false setget set_is_casting
var max_range = 192
var current_range = 0
var _parent

onready var _beam_particles = get_node("BeamParticles")
onready var _casting_particles = get_node("CastingParticles")
onready var _impact_particles = get_node("ImpactParticles")
onready var _line = get_node("Line")
onready var _tween = get_node("Tween")


func _ready():
	_casting_particles.emitting = false
	set_physics_process(false)
	_line.points[1] = Vector2.ZERO
	_parent = get_parent()

func _physics_process(delta):
	
	
	cast_point = cast_to
	force_raycast_update()
	
	_impact_particles.emitting = is_colliding()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		_impact_particles.global_rotation = get_collision_normal().angle()
		_impact_particles.position = cast_point
		
		
	_line.points[1] = cast_point
	_beam_particles.position = cast_point * 0.5
	_beam_particles.emission_rect_extents.x = cast_point.length() * 0.5
	_beam_particles.global_rotation = 0
	_casting_particles.lifetime = cast_point.length() / 192 + 0.07
	
	
func set_is_casting(cast):
	is_casting = cast
	
	_beam_particles.emitting = is_casting
	_casting_particles.emitting = is_casting
	if is_casting:
		appear()
	else:
		_impact_particles.emitting = false
		disapper()
	
	set_physics_process(is_casting)


func appear():
	_tween.stop_all()
	_tween.interpolate_property(_line, "width", 0, 10.0, 0.2)
	_tween.start()
	

func disapper():
	current_range = 0
	_tween.stop_all()
	_tween.interpolate_property(_line, "width", 10.0, 0, 0.1)
	_tween.start()
	
	

