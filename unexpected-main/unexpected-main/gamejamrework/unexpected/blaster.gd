extends CharacterBody2D

@export var projectile_scene: PackedScene # Drag your projectile scene here in the inspector
@export var projectile_speed: float = 800.0 # Adjust as needed
@export var shoot_cooldown: float = 0.2 # Time between shots

var can_shoot: bool = true
var shoot_timer: Timer

func _ready() -> void:
	# Initialize the shoot timer
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.one_shot = true
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta: float) -> void:
	# Blaster rotation and flipping (your existing code)
	rotate(%rotation.rotation)
	var mouse = get_global_mouse_position()
	if (mouse.x > %rotation.global_position.x):
		%Blaster.flip_v = false
	if (mouse.x < %rotation.global_position.x):
		%Blaster.flip_v = true

	# --- Shooting Logic ---
	if Input.is_action_pressed("shoot") and can_shoot: # Assuming "shoot" is your input action
		shoot()
		can_shoot = false # Prevent continuous shooting
		shoot_timer.start() # Start the cooldown

func shoot() -> void:
	if not projectile_scene:
		print("Error: Projectile scene not assigned!")
		return

	var projectile_instance = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile_instance) # Add to the current scene

	# Set projectile position to the blaster's global position
	projectile_instance.global_position = %Blaster.global_position

	# IMPORTANT CHANGE HERE: Set the projectile's rotation to match the blaster's
	projectile_instance.global_rotation = %Blaster.global_rotation

	# Calculate projectile direction based on the blaster's current rotation
	# Vector2(1, 0) represents the 'forward' direction when rotation is 0 (right)
	var shoot_direction = Vector2(1, 0).rotated(%Blaster.global_rotation)

	# Assuming your projectile has a 'velocity' property or a method to set its movement
	if "velocity" in projectile_instance:
		projectile_instance.velocity = shoot_direction * projectile_speed
	elif "set_direction_and_speed" in projectile_instance: # Example if you have a custom method
		projectile_instance.set_direction_and_speed(shoot_direction, projectile_speed)
	else:
		print("Warning: Projectile script needs a 'velocity' property or a method to set its movement.")

	print("Blaster shot a projectile!")

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
	print("Blaster ready to shoot again.")
