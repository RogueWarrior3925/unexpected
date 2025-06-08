extends CharacterBody2D

var health := 3

func take_damage(amount: int = 1) -> void:
	print("Enemy took damage:", amount, "Health before:", health)
	health -= amount
	print("Health now:", health)
	if health <= 0:
		print("Enemy died")
		queue_free()
var speed = randf_range(50, 100)

@onready var player = get_node("/root/GameJam/mc")


func _ready():
	pass

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
