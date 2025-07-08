extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal endAnimation

var initPose

# Called when the node enters the scene tree for the first time.
func _ready():
	$Animation.start()
	Utility.doorAnim = true
	initPose = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Utility.doorOpen
	if $Animation.time_left>0:
		self.position += Vector2(-Utility.doorAcc*delta, 0)
	else:
		#emit_signal("endAnimation")
		Utility.doorAnim = false
		self.position = initPose+Vector2(-64.146, 0)
		#queue_free()
		#$Player/Camera2D.current = true 
	pass
