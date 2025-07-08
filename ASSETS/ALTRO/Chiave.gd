extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cont = 0
var timeElapsed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Animation.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#timeElapsed += delta
	cont+=1
	#$Sprite.rotate(2*delta)
	if cont%100 < 50:
		$Sprite.flip_v=true
	else:
		$Sprite.flip_v = false
	
	if $Animation.time_left==0:
		queue_free()
		Utility.doorOpen = true
	#if timeElapsed > Utility.keyTime:
	#	self.queue_free()
