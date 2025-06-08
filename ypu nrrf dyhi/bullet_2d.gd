extends CharacterBody2D

const SPEED := 600
const RANGE := 1000
var travelled_distance := 0

func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance >= RANGE:
		queue_free()

func _on_Bullet_area_entered(body):
	print("Bullet hit:", body.name)
	if body.has_method("take_damage"):
		print("Calling take_damage on", body.name)
		body.take_damage(1)
	queue_free()


func _on_bullet_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
