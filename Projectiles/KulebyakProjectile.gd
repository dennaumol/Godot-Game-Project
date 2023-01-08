extends Area2D


var speed = 150
var damage = 8
var living_tick = 400

func _physics_process(delta):
	
	if scale.x >= 0.025:
		scale.y -= 0.02
		scale.x -= 0.02
	else:
		queue_free()
	position += transform.x * speed * delta
	living_tick -= 1
	if living_tick <= 0:
		queue_free()


func _on_KulebyakProjectile_body_entered(body):
	if not body.is_in_group("Enemies"):
		if body.is_in_group("Player"):
			body.take_damage(damage)
			queue_free()
		else:
			queue_free()
