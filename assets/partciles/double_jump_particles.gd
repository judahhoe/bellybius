extends CPUParticles2D

@onready var sfx = $DoubleJumpSFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true


func setsfx(amplitude):
	sfx.pitch_scale  = amplitude
	sfx.volume_db *= amplitude
	sfx.play()
