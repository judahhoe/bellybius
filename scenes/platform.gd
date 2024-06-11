extends StaticBody2D

@export var floor_particle_color: Color = Color("gray")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func pass_particle_color():
	return floor_particle_color
