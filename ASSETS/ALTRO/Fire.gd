extends KinematicBody2D

var velocity
#signal enemyKilled

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Utility.bulletVelocity[Utility.lastDirection]
	rotate(Utility.bulletAngles[Utility.lastDirection])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity.normalized()*delta*Utility.bulletAcc)
	#if collision:
	#	print(collision.collider.name)
	
	if collision:
		var collname = collision.collider.name
		if "TileMap" in collname or "Wall" in collname or "Exit" in collname:
		#and ("Player" in collision.collider.name or 
			queue_free()
		
		if "BrokenWall" in collname:
			collision.collider.queue_free()
			Utility.lastPoseBrokenWall = collision.collider.position
			Utility.startBrokenWall = true
			
		if "MovingBox" in collname or "Tube" in collname:
			queue_free()
		
		if "Enemy" in collision.collider.name:
			collision.collider.queue_free()
			queue_free()
			Utility.points += 30
			Utility.enemyKilled = true
			
			#REMOVE COIN SCENE IN DINAMIC AMBIENT
			#var coinScene = load("res://MonetaOro4.tscn");
			#var coinNode = coinScene.instance();
			#coinNode.position = Utility.playerPose
			#get_parent().get_parent().add_child(coinNode)
	

