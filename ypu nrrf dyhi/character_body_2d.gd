extends CharacterBody2D
@onready var playe2r = get_node(".../CharacterBody2D")
@onready var player = get_node("/root/GameJam/mc")
func _physics_process(delta: float) -> void:
	
	
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 105.0
	move_and_slide()
