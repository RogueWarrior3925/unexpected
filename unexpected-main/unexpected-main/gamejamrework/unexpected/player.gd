extends CharacterBody2D

# --- Movement Constants ---
@export var speed: float = 200

# --- Projectile Attack ---
@export var projectile_scene: PackedScene
@export var projectile_speed: float = 400.0
@export var projectile_offset: Vector2 = Vector2(30, 0) # Offset from player position
@export var projectile_cooldown: float = 0.8 # Cooldown time for shooting projectiles

var can_shoot_projectile: bool = true # Flag to track if projectile can be shot
@onready var projectile_cooldown_timer = Timer.new() # Timer node for projectile cooldown

# --- Nodes (for Health System UI) ---
# Assuming CanvasLayer is a sibling of the Player node. Adjust if it's a direct child.
@onready var health_bar = $"../CanvasLayer/HealthBar"
@onready var health_label = $"../CanvasLayer/HealthLabel"

# --- Health System ---
@export var max_health: int = 100 # Maximum health value, editable in Inspector
var current_health: int # Player's current health

# --- Signals (for Health System) ---
signal health_changed(new_health: int, max_health_val: int) # Emitted when health changes
signal died # Emitted when health drops to zero

func _ready() -> void:
	# Initialize health
	current_health = max_health
	update_health_bar() # Set initial health bar and label display

	# Setup projectile cooldown timer
	projectile_cooldown_timer.one_shot = true
	projectile_cooldown_timer.wait_time = projectile_cooldown
	# Corrected timeout connection to _on_projectile_cooldown_timeout
	projectile_cooldown_timer.timeout.connect(_on_projectile_cooldown_timeout)
	add_child(projectile_cooldown_timer)
	
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	move_and_slide()

	# Check for shooting input (assuming "shoot" action is defined)
	if Input.is_action_just_pressed("shoot") and can_shoot_projectile:
		shoot_projectile()

# --- Projectile Attack ---
func shoot_projectile():
	if not projectile_scene:
		print("Projectile scene not assigned!")
		return

	# Prevent shooting if on cooldown
	if not can_shoot_projectile:
		return

	can_shoot_projectile = false # Set to false to start cooldown
	projectile_cooldown_timer.start() # Start the cooldown timer

	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)

	# Determine facing direction for projectile offset and direction
	var facing_right = true # Assuming default right for non-flipped sprite in top-down
	# If you have an animated sprite for horizontal movement, you could use its flip_h property
	# if $AnimatedSprite2D:
	#	facing_right = not $AnimatedSprite2D.flip_h

	var offset = projectile_offset
	# Adjust offset based on facing direction if necessary for your sprite
	# For a top-down, you might need to adjust offset based on input_vector or fixed direction
	# For simplicity here, assuming projectile_offset is always applied in player's forward/right direction

	projectile.global_position = global_position + offset

	# Set projectile direction (e.g., based on player's velocity or last input direction)
	# For 8-directional movement, you might want projectile.direction = input_vector.normalized()
	projectile.direction = Vector2(1, 0) # Default to right if no specific direction logic is here
	# If you want it to shoot in the last movement direction:
	if velocity.length() > 0:
		projectile.direction = velocity.normalized()
	else: # If player is stationary, shoot based on some default (e.g., where player last faced)
		projectile.direction = Vector2(1,0) # Or adjust based on your game's default facing

	projectile.speed = projectile_speed

	print("Player shot a projectile!")


# --- Projectile Cooldown Reset ---
func _on_projectile_cooldown_timeout():
	can_shoot_projectile = true
	print("Projectile cooldown finished.")


## --- Health System Functions ---

# Called by enemies, projectiles, or other damaging objects to reduce health
func take_damage(amount: int):
	# Prevent taking damage if already dead
	if current_health <= 0:
		return

	current_health -= amount
	# Clamp health to ensure it stays within 0 and max_health
	current_health = clamp(current_health, 0, max_health) # Using Godot's clamp() function
	print(name, " took ", amount, " damage. Current health: ", current_health)

	# Update the UI elements (health bar and label)
	update_health_bar()
	# Emit signal for other parts of the game to react to health changes (e.g., sound, screen shake)
	health_changed.emit(current_health, max_health)

	# Check if player has died
	if current_health <= 0:
		die()

# Optional: Function to take damage from a specific attacker (for logging or specific reactions)
func take_damage_from_attacker(amount: int, attacker: Node = null):
	print(name, " was attacked by ", attacker.name if attacker else "unknown attacker")
	take_damage(amount) # Calls the main take_damage function

# Healing function to restore health
func heal(amount: int):
	current_health += amount
	# Clamp health to ensure it doesn't exceed max_health
	current_health = clamp(current_health, 0, max_health) # Using Godot's clamp() function
	print(name, " healed for ", amount, ". Current health: ", current_health)

	# Update the UI elements
	update_health_bar()
	# Emit signal for other parts of the game to react to health changes
	health_changed.emit(current_health, max_health)

# Called when health drops to zero
func die():
	print(name, " has died!")
	died.emit() # Emit signal for game manager to handle game over, respawn, etc.
	get_tree().reload_current_scene() # Example: Reloads the current scene, effectively respawning the player

# Updates the UI elements for health bar (ProgressBar) and label (Label)
func update_health_bar():
	# Update the health bar's max_value and current value
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
	else:
		print("Warning: Health bar node not found! Check the path in @onready var health_bar.")
		
	# Update the health label's text
	if health_label:
		health_label.text = str(current_health) + " / " + str(max_health)
	else:
		print("Warning: Health label node not found! Check the path in @onready var health_label.")

# Renamed _on_timer_timeout to match the projectile cooldown timer connection
# This function is now specifically for the projectile cooldown
func _on_timer_timeout() -> void:
	# This function is now technically redundant as _on_projectile_cooldown_timeout handles the logic.
	# You can remove this empty function if _on_projectile_cooldown_timer was the only thing it was connected to.
	pass
