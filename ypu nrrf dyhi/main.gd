extends Node2D
var cursorenemy = preload("res://enemysight.png")
var cursorfriend = preload("res://friendlysight.png")
var current = "friend"
var prev = "friend"
signal lost
var bullet_scene = preload("res://Bullet.tscn")  # Adjust path

	
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = get_viewport().get_mouse_position()
	bullet.rotation = 0  # Point right; adjust if you want direction
	get_tree().current_scene.add_child(bullet)
	
func _ready() -> void:
	spawn_enemy()
	
func _physics_process(_delta: float) -> void:
	pass
		
		
	
func spawn_enemy():
	var new_mob = preload("res://enemy.tscn").instantiate()
	%PathFollow2D.progress_ratio=randf()
	new_mob.global_position=%PathFollow2D.global_position
	add_child(new_mob)
	
func spawn_friend():
	var new_friend = preload("res://friend.tscn").instantiate()
	%PathFollow2D.progress_ratio=randf()
	new_friend.global_position=%PathFollow2D.global_position
	add_child(new_friend)
	


func _on_enemy_timer_timeout() -> void:
	spawn_enemy()
	



func _on_friend_timer_timeout() -> void:
	spawn_friend()


func _on_hitbox_body_entered(body: Node2D) -> void:
	
		%lose.show()
		get_tree().paused = true
