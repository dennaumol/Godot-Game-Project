extends Area2D

var speed = 350
var damage = 25
var living_tick = 400

func _physics_process(delta):
	position += transform.x * speed * delta
	living_tick -= 1
	if living_tick <= 0:
		queue_free()


func _on_AlienProjectileGreen_body_entered(body):
	if not body.is_in_group("Enemies"):
		queue_free()
		if body.is_in_group("Player"):
			body.take_damage(damage)
