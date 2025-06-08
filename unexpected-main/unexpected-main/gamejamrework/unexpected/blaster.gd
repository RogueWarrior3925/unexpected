extends CharacterBody2D



func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	# Blaster rotation and flipping (your existing code)
	rotate(%rotation.rotation)
	var mouse = get_global_mouse_position()
	if (mouse.x > %rotation.global_position.x):
		%Blaster.flip_v = false
	if (mouse.x < %rotation.global_position.x):
		%Blaster.flip_v = true


func shoot() -> void:
	pass



	
