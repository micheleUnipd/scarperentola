extends KinematicBody2D

var initPose
const UP = Vector2(0, -300) 
var collision
var playerEnemy = false
var timerPlayerEnemy = 3
var cont = 0

var scene1Pose = Vector2(47, 251)
var scene2Pose = Vector2(1110, -376)
var scene3Pose = Vector2(50, -950)
var scene4Pose = Vector2(1260, -1372)
var scene5Pose = Vector2(1450, 400)
var scene5Bridge = Vector2(2706, -732)
var scene6Pose = Vector2(3450, 486)
var scene7Pose = Vector2(3603, -1331)
var scene8Pose = Vector2(3100, -1400)

signal enemyCollision
signal movingBoxCollision

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#print("game start!")
	Utility.inGame = true
	initPose = position
	#print(initPose)
	
	#temporary jump to scene 6
	#Utility.currentScene = 1
	#position = scene1Pose
	#initPose = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(position)
	if Utility.inGame:
		
		Utility.playerPose = self.position
		if Utility.check_collision_eps(position, scene2Pose, 1.5):
			initPose = scene2Pose
			Utility.currentScene = 2
		
		if Utility.check_collision_eps(position, scene3Pose, 1.5):
			initPose = scene3Pose
			Utility.currentScene = 3
			
		if Utility.check_collision_eps(position, scene4Pose, 1.5):
			initPose = scene4Pose
			Utility.currentScene = 4
		
		if Utility.check_collision_eps(position, scene5Pose, 1.5):
			initPose = scene5Pose
			Utility.currentScene = 5
		
		if Utility.check_collision_eps(position, scene6Pose, 1.5):
			initPose = scene6Pose
			Utility.currentScene = 6
			
		var velocity = Vector2();
	
		#add gravity effect
		if Utility.gravity and not Utility.inPlat and not Utility.onStair and $Jump.time_left==0:
		#print("adding gravity effect") 
			collision = move_and_collide(Utility.gravityVector.normalized()*delta*Utility.scarpAcc)
	
	#synchronize player and platform 
	#if Utility.inPlat and not Utility.onStair:
		#move_and_collide(Utility.onPlatVelocity.normalized()*delta*Utility.platformAcc)
	#	move_and_collide(Utility.gravityVector.normalized()*delta*Utility.scarpAcc/100)
	
	
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
			collision = move_and_collide(UP*delta)
		
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
		if collision and collision.collider and ("Sea" in collision.collider.name or "Kill" in collision.collider.name):
			#print(position)
			#move_and_collide(Vector2(initPose.x-150, initPose.y-50)-self.position)
			self.position = Vector2(initPose.x, initPose.y)
			Utility.lifes -= 1
		
		
		if collision and "Coin" in collision.collider.name:
			#print("Collision Player Coin")
			Utility.coinCollect = true
			#print(collision.collider.name)
			collision.collider.queue_free()
		
		if collision and "Key" in collision.collider.name:
			if "LastKey" in collision.collider.name:
				Utility.lastKeyTaken = true
				
			else:
				collision.collider.queue_free()
				Utility.keyTaken = true
		
		#if collision and "LeftLever" in collision.collider.name:
		#	Utility.leverOn[Utility.currentScene] = true #il player ha attivato la leva nella scena corrente
		
		if collision and "StairExtends" in collision.collider.name:
			Utility.leverOn[3] = true
		
		if collision and "BridgeExtends" in collision.collider.name:
			#Utility.leverOn[Utility.currentScene] = true #il player ha attivato la leva nella scena corrente
			Utility.leverOn[5] = true
			
		if collision and "BridgeRemove" in collision.collider.name:
			Utility.leverOn[6] = true
		
		if collision and Utility.keyTaken and "PadLock" in collision.collider.name:
			#Utility.doorOpen = true
			Utility.keyUsed = true
		
		if collision and Utility.lastKeyTaken and "PadLock" in collision.collider.name:
			#Utility.doorOpen = true
			Utility.lastKeyUsed = true
		
		if collision and "ExtendsStair1" in collision.collider.name:
			Utility.extendsStair1 = true
			
		if collision and "ExtendsStair2" in collision.collider.name:
			Utility.extendsStair2 = true
		
		#IL MURO SI ROMPE CON IL PROIETTILE
		#if collision and "BrokenWall" in collision.collider.name:
		#	collision.collider.queue_free()
		#	Utility.startBrokenWall = true
		
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
		
		if collision and "MovingBox" in collision.collider.name:
			if velocity.x!=0:
				var boxCol = collision.collider.move_and_collide(velocity.x*Utility.platformAcc*delta*Vector2(1, 0))
				if "MovingBox4" in collision.collider.name:
					if boxCol and boxCol.collider and "Wall" in boxCol.collider.name:
						Utility.lastKeyTaken = true 
						#print("Box collide with "+boxCol.collider.name)
		
		if velocity == Vector2():
			if $Player.animation == "walk_down":
				$Player.play("stand_down")
			elif $Player.animation == "walk_left":
				$Player.play("stand_left")
			elif $Player.animation == "walk_up":
				$Player.play("stand_up")
