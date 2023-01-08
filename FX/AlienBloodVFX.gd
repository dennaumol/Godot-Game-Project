extends CPUParticles2D


var current_lifetime

func _ready():
	current_lifetime = lifetime

func _physics_process(delta):
	if current_lifetime <= 0:
		queue_free()
	current_lifetime -= delta
