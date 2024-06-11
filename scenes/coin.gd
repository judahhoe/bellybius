extends Node2D

@onready var particles = $CPUParticles2D
@onready var animation = $AnimationPlayer
@onready var animation2 = $AnimationPlayer2

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("float")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.has_method("interact"):
		#body.interact()
		animation2.play("collect")
		#particles.emitting = true
		await get_tree().create_timer(0.3).timeout
		queue_free()
