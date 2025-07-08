extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#simulate the gravity force for a Kinematic Body
	var collision = move_and_collide(Utility.platformAcc*delta*Vector2(0, 1))
	if collision and "BrokenWall" in collision.collider.name:
		Utility.brokenGround = true
