extends CharacterBody2D

@onready var particles = $CPUParticles2D
@onready var animation_player = $AnimationPlayer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("spawn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func _on_timer_timeout():
	particles.emitting = true
