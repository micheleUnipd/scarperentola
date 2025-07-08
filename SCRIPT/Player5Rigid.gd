extends RigidBody2D

var initPose
const UP = Vector2(0, -300) 
var collision
var playerEnemy = false
var timerPlayerEnemy = 3
var cont = 0
var scene2Pose = Vector2(1110, -376)
var scene3Pose = Vector2(50, -950)

signal enemyCollision

# Called when the node enters the scene tree for the first time.
func _ready():
	print("game start!")
	Utility.inGame = true
	initPose = position
	#print(initPose)
	
	#temporary jump to scene 2
	#position = scene2Pose
	#position = scene3Pose

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(position)
	
	Utility.playerPose = self.position
	if Utility.check_collision_eps(position, scene2Pose, 1.5):
		initPose = scene2Pose
	
	var velocity = Vector2();
	
	#add gravity effect
	if Utility.gravity and not Utility.inPlat and not Utility.onStair and $Jump.time_left==0:
		#print("adding gravity effect") 
		collision = move_and_collide(Utility.gravityVector.normalized()*delta*Utility.scarpAcc)
		
	
	#synchronize player and platform 
	#if Utility.inPlat and not Utility.onStair:
		#move_and_collide(Utility.onPlatVelocity.normalized()*delta*Utility.platformAcc)
	#	move_and_collide(Utility.gravityVector.normalized()*delta*Utility.scarpAcc/100)
	
	if Utility.inGame:
		#if Input.is_key_pressed(KEY_W):# and (self.position.y > miny):
			#print(self.position.x)
		#	$Player.play("walk_up")
		#	velocity.y = -1
		#	Utility.lastDirection = 1
			#self.position.y -= velocity;
		#if Input.is_key_pressed(KEY_S):#and (self.position.y < maxy):
		#	$Player.play("walk_down")
		#	velocity.y = 1
		#	Utility.lastDirection = 3 
			#self.position.y += velocity;
		
		#if is_on_floor() or true:
			#print("is on floor")
		if $Jump.time_left > 0:
			move_and_collide(UP*delta)
		
		if Input.is_key_pressed(KEY_SPACE) and $JumpCoolDown.time_left==0 and Utility.inGame:
			#if Input.is_action_just_pressed("ui_space"):
			$JumpCoolDown.start()
			$Jump.start()
			#velocity.y = Utility.jumpAcc
			#move_and_collide(velocity)
			#velocity = move_and_slide(velocity, UP)
			
		
		if Input.is_key_pressed(KEY_A) and Utility.inGame:# and (self.position.x > minx):
			$Player.play("walk_left")
			$Player.flip_h = false
			#self.move_and_collide(velocity.normalized()*delta*Utility.scarpAcc/1.5)
			velocity.x = -1
			Utility.lastDirection = 2
			#self.position.x -= velocity;
		if Input.is_key_pressed(KEY_D) and Utility.inGame:# and (self.position.x < maxx):
			$Player.play("walk_left")
			$Player.flip_h = true
			#self.move_and_collide()
			velocity.x = 1
			Utility.lastDirection = 0
		 #self.position.x += velocity;
		
		if Input.is_key_pressed(KEY_W) and Utility.inGame and Utility.onStair:
			$Player.play("walk_up")
			velocity.y = -1
		
		if Input.is_key_pressed(KEY_S) and Utility.inGame and Utility.onStair:
			$Player.play("walk_down")
			velocity.y = +1
		
		#right, left and up movement of the player
		if(velocity!=Vector2()):
			collision = self.move_and_collide(velocity.normalized()*delta*Utility.scarpAcc/1.5);
		
		#if collision and not "Platform" in collision.collider.name: 
		#	print("Player collide with:"+collision.collider.name)
		
		#print("Collision with: "+collision.collider.name)
		
		#if collision and "WallDown" or "Sea" in collision.collider.name:
		if collision and ("Sea" in collision.collider.name or "Kill" in collision.collider.name):
			#print(position)
			#move_and_collide(Vector2(initPose.x-150, initPose.y-50)-self.position)
			self.position = Vector2(initPose.x, initPose.y)
			Utility.lifes -= 1
		
		
		if collision and "Coin" in collision.collider.name:
			#print("Collision Player Coin")
			Utility.coinCollect = true
			
			print(collision.collider.name)
			collision.collider.queue_free()
		
		if collision and "Key" in collision.collider.name:
			collision.collider.queue_free()
			Utility.keyTaken = true
		
		if collision and "LeftLever" in collision.collider.name:
			Utility.leverOn = true
		
		
		if collision and Utility.keyTaken and "PadLock" in collision.collider.name:
			#Utility.doorOpen = true
			Utility.keyUsed = true
		
		#temporary collision detection to the wall
		#if position.y > Utility.maxY+150:
		#	self.position = Vector2(initPose.x, initPose.y)
		#	$CollisionShape2D.disabled = false
		
		if playerEnemy:
			timerPlayerEnemy-=delta
			#Lampeggio 4/10 spento 6/10 acceso
			cont+=1
			if cont%10 < 4:
				$Player.visible = false
			else:
				$Player.visible = true
		
		if timerPlayerEnemy<0:
			playerEnemy = false
			timerPlayerEnemy = 3
			$Player.visible = true
		
		if collision and "Enemy" in collision.collider.name and $LifesCoolDown.time_left==0:
			#print("enemy collision")
			#collision.collider.move_and_collide(Vector2(50, 0))
			#collision.collider.move_and_collide(Vector2(0, 50))
			#collision.collider.move_and_collide(Vector2(-50, 0))
			#collision.collider.move_and_collide(Vector2(0, -50))
			$LifesCoolDown.start()
			playerEnemy = true
			emit_signal("enemyCollision")
		
		
		if velocity == Vector2():
			if $Player.animation == "walk_down":
				$Player.play("stand_down")
			elif $Player.animation == "walk_left":
				$Player.play("stand_left")
			elif $Player.animation == "walk_up":
				$Player.play("stand_up")
