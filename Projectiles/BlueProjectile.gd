extends Area2D

var speed = 650
var damage = 40
var living_tick = 70

func _physics_process(delta):
	position += transform.x * speed * delta
	living_tick -= 1
	if living_tick <= 0:
		queue_free()

func _on_Bullet_body_entered(body):
	if not body.is_in_group("Player"):
		queue_free()
		if body.is_in_group("Enemies"):
			body.take_damage(damage)
	


