extends Node2D

@onready var sprite = $AnimatedSprite2D
@export var dialogue : String
@onready var speech_bubble = $RichTextLabel
@onready var audio = preload("res://sfx/blah.tscn")
var alreadyTalked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func talk():
	if not alreadyTalked:
		var i = 0
		alreadyTalked = true
		speech_bubble.visible = true
		sprite.play("talk")
		while (i<= dialogue.length()):
			var audio_instance = audio.instantiate()
			owner.add_child(audio_instance)
			speech_bubble.custom_minimum_size.x = 15*i
			await get_tree().create_timer(0.04).timeout
			speech_bubble.text = dialogue.left(i)
			i+=1
		sprite.play("default")
		await get_tree().create_timer(10).timeout
		speech_bubble.visible = false


func _on_area_2d_area_entered(area):
	print(area)
	talk()
