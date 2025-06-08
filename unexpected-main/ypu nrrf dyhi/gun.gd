extends Area2D

@export var shoot_button: String = "shoot"

const BULLET = preload("res://bullet_2d.tscn")

func _process(_delta):

	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed(shoot_button):
		shoot()

func shoot():
	var new_bullet = BULLET.instantiate()
	new_bullet.global_transform = %ShootingPoint.global_transform
	get_tree().current_scene.add_child(new_bullet)
