extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -110.0

var main_node
var floor_tiles

@onready var base_collider = preload("res://scenes/bellybius_base_collider.tres")
@onready var bloated_collider = preload("res://scenes/bellybius_bloated_collider.tres")
@onready var collider = $CollisionShape2D


@onready var butt_marker = $Sprite2D/ButtMarker
@onready var doublejump_particles = preload("res://assets/partciles/double_jump_particles.tscn")
#@onready var doublejump_particles = $Sprite2D/ButtMarker/DoubleJumpParticles

@onready var landing_particles = preload("res://scenes/landing_particles.tscn")
@onready var running_particles = $RunningParticles
@onready var sprite = $Sprite2D
@onready var feet_marker = $FeetMarker
@onready var animation_player = $AnimationPlayer
@onready var charge_area = $ChargeArea
@onready var charge_timer = $ChargeTimer
@onready var interact_area = $InteractArea

var isFallTimerCounting = false

#bools and locals
var hasJumped = false
var step_counter = 0
var isInteracting = false
var isMoving = false
var isCharging = false
var last_direction
var canCharge = true
var isOnObject = false
var isBloated = false
var hasDoubleJumped = false

var base_rotation

# Get the gravity from the project settings to be synced with RigidBody nodes.
var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = base_gravity

func _ready():
	main_node = get_node("/root/main")
	collider.shape = base_collider
	base_rotation = sprite.rotation
	floor_tiles = $main_node/Ground

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 10 and !isCharging and !isBloated:
			sprite.play("fall")
			if velocity.y > 200:
				sprite.speed_scale *= 1.05
			if velocity.y > 400:
				sprite.speed_scale *= 1.05
			if velocity.y > 1000:
				sprite.speed_scale *= 1.05
	
	if is_on_floor():
		sprite.speed_scale = 1
	
	if hasJumped and is_on_floor():
		emit_landing_particles()
		animation_player.play("land")
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		await get_tree().create_timer(0.04).timeout
		if (is_on_floor() or isOnObject):
			hasJumped = true
			velocity.y = JUMP_VELOCITY
			await get_tree().create_timer(0.04).timeout
		elif (!is_on_floor() or !isOnObject):
			if !hasDoubleJumped:
				hasJumped = true
				hasDoubleJumped = true
				
				var doublejump_particles_instance = doublejump_particles.instantiate()
				var jump_amplitude = randf_range(0.6,1.4)
				butt_marker.add_child(doublejump_particles_instance)
				doublejump_particles_instance.setsfx(jump_amplitude)
				velocity.y = JUMP_VELOCITY * jump_amplitude

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	last_direction = direction
	if direction:
		isMoving = true
		velocity.x = handle_movement(direction)
	else:
		isMoving = false
		if (is_on_floor() or isOnObject) && !isInteracting && !isBloated:
			sprite.play("idle")
		running_particles.emitting = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("interact") and !isInteracting and !isBloated and !isCharging:
		if is_on_floor():
			interact()
	if event.is_action_pressed("charge") and !isCharging and canCharge and !isBloated:
		charge()
	'''
	if event.is_action_pressed("bloat") and !isInteracting and !isCharging:
		if !isBloated:
			get_bloated()
		elif isBloated:
			unbloat()
	'''


func charge():
	if velocity.x != 0:
		charge_timer.start()
		canCharge = false
		isCharging = true
		charge_area.monitoring = true
		sprite.play("charge")
		await get_tree().create_timer(0.3).timeout
		charge_area.monitoring = false
		isCharging = false

func handle_movement(direction):
	if is_on_floor()  or isOnObject:
		#if(step_counter == 0):
			#animation_player.play("walk_0")
		#if(step_counter == 1):
			#animation_player.play("walk_1")
		if !isCharging and !isBloated:
			sprite.play("walk")
		emit_walk_particles()
	if !is_on_floor():
		running_particles.emitting = false
	scale.x = scale.y * direction #flippin sprite to direction
	velocity.x = direction * SPEED
	if isBloated:
		print(direction)
		sprite.rotation += 0.01
	if isCharging:
		velocity.x = direction * SPEED * 3
	return velocity.x

func emit_walk_particles():
	get_floor_color(running_particles)
	running_particles.emitting = true

func emit_landing_particles():
	var landing_particles_instance = landing_particles.instantiate()
	get_floor_color(landing_particles_instance)
	landing_particles_instance.emitting = true
	landing_particles_instance.position = feet_marker.global_position
	main_node.add_child(landing_particles_instance)
	hasJumped = false
	hasDoubleJumped = false

func get_floor_color(particle):
	pass
	#if is_on_floor():
		#var  floor = floor_tiles.get_cell_tile_data(1, position)
		#if floor != null:
			#particle.color = floor.get_custom_data("Floor_color")

func interact():
	isInteracting = true
	sprite.play("pickup")
	await get_tree().create_timer(0.3).timeout
	if sprite.animation_finished:
		isInteracting = false
'''
func get_bloated():
	velocity.y = -100
	isBloated = true
	sprite.play("bloated")
	collider.shape = bloated_collider

func unbloat():
	velocity.y = 3
	isBloated = false
	collider.shape = base_collider
	sprite.rotation = base_rotation
'''

func drink():
	sprite.play("drink")

func bin_fart():
	var doublejump_particles_instance = doublejump_particles.instantiate()
	var jump_amplitude = 4
	butt_marker.add_child(doublejump_particles_instance)
	doublejump_particles_instance.setsfx(jump_amplitude)
	velocity.y = JUMP_VELOCITY * 2
	

func _on_step_timer_timeout():
	if step_counter == 0:
		step_counter = 1
	if step_counter == 1:
		step_counter = 0

func _on_charge_area_body_entered(body):
	if body.has_method("get_charged"):
		body.get_charged(last_direction)
	if body.has_method("destroy"):
		body.destroy()
	print(body)


func _on_charge_timer_timeout():
	canCharge = true


func _on_feet_area_body_entered(body):
	isOnObject = true
	gravity = 0
	velocity.y = 0
	#body.lock_movement()


func _on_feet_area_body_exited(body):
	isOnObject = false
	gravity = base_gravity
	#body.unlock_movement()
