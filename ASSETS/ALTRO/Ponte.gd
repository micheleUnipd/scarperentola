extends Node2D

signal endAnimation

var initPose
var animCont = 0
var bridgeSec = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Animation.start()
	#Utility.bridgeAnim = false
	initPose = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(delta)
	#if Utility.doorOpen
	animCont += delta
	#print(animCont)
	if $Animation.time_left>0:
		if (animCont>1):
			animCont=0
			bridgeSec += 1
			get_node_or_null("Sprite"+str(bridgeSec)).visible = true
			
		#self.position += Vector2(-Utility.doorAcc*delta, 0)
	else:
		#emit_signal("endAnimation")
		Utility.bridgeAnim[5] = true
		#self.position = initPose+Vector2(-64.146, 0)
		#queue_free()
		#$Player/Camera2D.current = true 
	pass
