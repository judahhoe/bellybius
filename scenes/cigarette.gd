extends Node2D

@onready var particles_0 = $CPUParticles2D
@onready var particles_1 = $CPUParticles2D2
var part = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if !part:
		particles_0.emitting = true
		particles_1.emitting = false
		part = true
	elif part:
		particles_0.emitting = false
		particles_1.emitting = true
		part = false
