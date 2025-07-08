extends Node2D

var movement = 2
var velocity = [Vector2(0, movement), Vector2(0, -1*movement), Vector2(0, movement), Vector2(0, movement),
				Vector2(0, movement), Vector2(0, -1*movement), Vector2(0, movement), Vector2(0, movement),
				Vector2(0, movement), Vector2(0, -1*movement), Vector2(0, movement), Vector2(0, movement),
				Vector2(0, movement), Vector2(0, -1*movement), Vector2(0, movement), Vector2(0, movement)]

var nPlat = len(velocity) #11
var nEnemy = 2
var nStair = 100
var nBridge = 8
var stairNode
var anyStair
var platNode
var enemyNode
var tubeNode
var collShape
var pose
var refineMin = 500
var refineMax = 50
var currentPlatform
var currentIndex
var ncollision = 0
var anyPlatform = false
var onPlatNode
var onPlatVelocity
var coinTime = 0 
var collision
var timeElapsed = 0
var timeAnimation = 2
var keyOffset = Vector2(-60, 40)
var stairCount = 17
var animCount = 0
#var brokenWallPose

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Utility.scaling
	Utility.inGame = true
	Utility.gravity = false
	Utility.points = 0
	Utility.lifes = RoomsManager.lifes
	
	$CanvasLayer/Alert.get_cancel().connect("pressed", self, "cancelled") #link cancel button in alert to the function
	$CanvasLayer/Exit.focus_mode = 0 #evita problema del pulsante exit che si attiva casualmente con la pressione
	#del tasto barra spaziatrice
	
	#brokenWallPose = get_node_or_null("BrokenWall").position
	#brokenWallPose = Vector2(3508, -1369)
	for i in range(1, nEnemy+1):
		#SAVE THE STARTING POSITION OF THE ALL ENEMY IN THE TUBES
		Utility.startEnemyTube[i-1] = get_node_or_null("Enemy"+str(i)).position #+Vector2(0, 0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#print(Utility.playerPose)
	
	#update time elapsed and lifes in the bar
	$CanvasLayer/Vite.text = str(Utility.lifes)
	timeElapsed+=delta
	Utility.updateTime(delta)
	$CanvasLayer/Tempo.text=str(Utility.timeCalculate(Utility.seconds)[0])+":"+str(Utility.timeCalculate(Utility.seconds)[1])+":"+str(Utility.timeCalculate(Utility.seconds)[2])
	
	#variable used to check if the player is on a platform
	anyPlatform = false
	
	#moving the enemy in the tube
	for i in range(1, nEnemy+1):
		
		enemyNode = get_node_or_null("Enemy"+str(i)) as KinematicBody2D
		tubeNode = get_node_or_null("Tube"+str(i)) as StaticBody2D
		collShape = get_node_or_null("Tube"+str(i)+"/CollisionShape2D") as CollisionShape2D
		
		if enemyNode: #il player può uccidere il nemico tramite il proiettile
		
			if (int(timeElapsed)%10 < 5):
				enemyNode.visible = true
				#$Tube/CollisionShape2D.disabled = true
				collShape.disabled = true
				enemyNode.move_and_collide(Vector2(0, -movement).normalized()*delta*Utility.platformAcc*0.015)
			else:
				enemyNode.visible = false
				#$Tube/CollisionShape2D.disabled = false
				#enemyNode.position = Vector2(113.181, 78.206)
				collShape.disabled=false
				#enemyNode.move_toward(Utility.startEnemyTube[i-1], 100)
				enemyNode.position = Utility.startEnemyTube[i-1]
				#enemyNode.move_and_collide(enemyNode.position.direction_to(Utility.startEnemyTube[i-1]))
				#enemyNode.position.move_toward(Utility.startEnemyTube[i-1], 50) #-enemyNode.position)
				#enemyNode.position = get_node_or_null("Tube"+str(i)+"/Tube").position #tubeNode.position#+Vector2(120, 110)
		
	
	#control the platform movement
	for i in range(1, nPlat+1):
		platNode = get_node_or_null("PlatformMove"+str(i)) as KinematicBody2D#+"/TileMap")
		#pose = platNode.get_child(0).position
		#print(pose)
		if platNode!=null:
			pose = platNode.position
			collision = platNode.move_and_collide(velocity[i-1].normalized()*delta*Utility.platformAcc);
			
			#same functionality as the move and collide
			#platNode.move_and_slide(velocity[i-1].normalized()*Utility.platformAcc);
			#for j in platNode.get_slide_count():
			#	var collDetect = platNode.get_slide_collision(j)
			#	print("Collided with: ", collDetect.collider.name)
			#	if collDetect and ("Wall" in collDetect.collider.name or "Sea" in collDetect.collider.name 
			#	or "Player" in collDetect.collider.name):
			#		velocity[i-1] *= -1
			
		#reverse move
		#if platNode!=null and (pose.y > Utility.maxY or pose.y<Utility.minY-refineMin):
		#	velocity[i-1] *= -1
		
		#reverse move to UP
		#if platNode!=null and pose.y > Utility.maxY:
		#	velocity[i-1] = Vector2(0, -1*movement)
		
		#reverse move to DOWN
		#if platNode!=null and pose.y<Utility.minY-refineMin:
		#	velocity[i-1] = Vector2(0, movement)
		
		
		#if platNode!=null and (platNode.position.y > Utility.maxY or platNode.position.y<Utility.minY):
			#reverse move
		#	velocity[i-1] *= -1
		
			
		#var collision = platNode.move_and_slide(velocity[i-1].normalized()*Utility.platformAcc)
		
		#if collision: print("Platform collide with "+collision.collider.name)
		
		#if collision and "Ground" in collision.collider.name:
		#	velocity[i-1] *= -1
		
		
		#if Utility.check_collision_eps(Utility.playerPose, platNode.position, 1.2):
		#	currentIndex = i-1
			#Utility.inPlat = true
		#	anyPlatform = anyPlatform or true
		#	print("Collision Player Platform")
		
		#if platNode!=null and Utility.check_collision_eps(platNode.get_node("Sprite").position, Utility.playerPose, 5):
		#	print("Collision Player Platform function method")
		#	print("Player position x: "+str($Player.position.x))
		#	print("Player position y: "+str($Player.position.y))
		#	print("Platform position x: "+str(platNode.position.x))
		#	print("Platform position y: "+str(platNode.position.y))
		
		#check if the player is on moving platform or not, save the relative velocity
		if collision and "Player" in collision.collider.name:
			currentIndex = i-1
			anyPlatform = anyPlatform or true
			onPlatNode = platNode
			Utility.onPlatVelocity = velocity[currentIndex]
			
			#TO CHECK !!!
			#positions of the player and the platform is not managed correctly
			#print("Collision Player Platform")
			#print("Player position x: "+str($Player/Player.position.x))
			#print("Player position y: "+str($Player/Player.position.y))
			#if platNode:
			#	print("Platform position x: "+str(platNode.get_node_or_null("Sprite").position.x))
			#	print("Platform position y: "+str(platNode.get_node_or_null("Sprite").position.y))
			#	print("Platform position x: "+str(platNode.position.x))
			#	print("Platform position y: "+str(platNode.position.y))
			
			#$Player.move_and_collide(Vector2(0, -1*movement*delta*Utility.platformAcc*10))
			#platNode.move_and_collide(velocity[i-1].normalized()*delta*Utility.platformAcc);
			
			#$Player/CollisionShape2D.disabled = true
		
		#reverse the direction of the platform
		if collision and ("Wall" in collision.collider.name or "Sea" in collision.collider.name 
		or "Player" in collision.collider.name or "Bridge" in collision.collider.name):
			velocity[i-1] *= -1
			
			
	#end control platform movement
	
	if Utility.coinCollect:
		Utility.points += Utility.coinPoints
		$CoinAnimation.start()
		#update points in the top bar menu
		$CanvasLayer/Monete.text = str(Utility.points)
		Utility.coinCollect = false
			
		
			#$Player.get_child(1).disabled = true
			#$Player.move_and_collide(velocity[i-1].normalized()*delta*Utility.platformAcc*0.5)
		
			
		#if not collision:
		#	ncollision -= 1
		#else:
		#	ncollision = 0
		#	Utility.gravity = true
		
		#if not Utility.gravity:
			#$Player.move_and_collide(velocity[currentIndex].normalized()*delta*Utility.platformAcc*0.47)
		#	$Player.move_and_collide(Vector2(0, -1*movement*delta*Utility.platformAcc*10))
			
		#if ncollision < -10:
		#	Utility.gravity = true
		
		#print(platNode.get_child(0))
		#pose += velocity[i-1].normalized()*delta*Utility.platformAcc
		#platNode.get_child(0).position += velocity[i-1]
		#Utility.gravity=false
	
	#check that the Player is on a stair or not
	anyStair = false
	for i in range(2, nStair):
		stairNode = get_node_or_null("Stair"+str(i)) as Sprite#+"/TileMap")
		if stairNode!=null and Utility.check_collision_eps($Player.position, stairNode.position, 1.5) and stairNode.visible:
			anyStair = true
			#print("Player collision with the stair")
			break
			
	Utility.onStair = anyStair
	
	
	#Control the coin animation in the top bar
	if $CoinAnimation.time_left>0:
		$CanvasLayer/Moneta.rotate(0.5)
		coinTime += 1
		if coinTime%10 < 5:
			$CanvasLayer/Monete.visible = true
		else:
			$CanvasLayer/Monete.visible = false
			
	else:
		if Utility.inGame: $CanvasLayer/Monete.visible = true
		$CanvasLayer/Moneta.rotation_degrees = 0
		
	
	Utility.inPlat = anyPlatform
	#disable gravity if the player is on a moving platform
	Utility.gravity = not Utility.inPlat
	
	if Utility.onStair:
		$Player.set_safe_margin(Utility.normalMargin)
	else:
		$Player.set_safe_margin(Utility.onPlatMargin)
	
		#$Player.set_safe_margin(Utility.onPlatMargin)
		
		#$Player.move_and_collide(Utility.onPlatVelocity.normalized()*delta*Utility.platformAcc)
		#$Player/CollisionShape2D.disabled = true
		#onPlatNode.get_child(1).disabled = true
		#platNode.move_and_collide(velocity[currentIndex].normalized()*delta*Utility.platformAcc) #0.47???
		#$Player.move_and_collide(velocity[currentIndex].normalized()*delta*Utility.platformAcc*100)
		
	
		#$Player.set_safe_margin(Utility.normalMargin)
		#$Player.collision = Utility.normalMargin
		
	#if onPlatNode and Utility.check_collision_eps(onPlatNode.position, Utility.playerPose, 1):
	#	$Player.move_and_collide(velocity[currentIndex-1].normalized()*delta*Utility.platformAcc)
	
	if Utility.keyUsed:
		$Door2.visible = false
		loadKey("Chiave", Utility.playerPose+keyOffset, true)
		Utility.keyTaken = false
		Utility.keyUsed = false
	
	if Utility.lastKeyUsed:
		$Door3.visible = false
		loadKey("Chiave", Utility.playerPose+keyOffset, false)
		Utility.lastKeyTaken = false
		Utility.lastKeyUsed = false
	
	if Utility.doorOpen:
		$Door2/StaticBody2D/CollisionShape2D.disabled = true
		#Vector2(96.151, -799.968)
		Utility.doorOpen = false
		loadDoor("Porta", $Door2.position, true)
		
		#var doorNode = get_node_or_null("Door") as TileMap
		#doorNode.queue_free()
	
	if Utility.startBrokenWall:
		Utility.startBrokenWall = false
		brokenWall("MuroRotto")
	
	# move the camera to the door during the open animation
	#return to the player at the end
	if Utility.doorAnim:
		$Door2/Camera2D.current = true
	else:
		$Player/Camera2D.current = true
	
	
	if Utility.leverOn[3]:
		#$RightLever3.visible = false
		#$LeftLever3.visible = true
		$StairExtends/Sprite.visible = false
		$StairExtends/Sprite2.visible = true
		$StairAnimation.start()
		loadStair(21)
	
	if Utility.leverOn[5]:
		#$RightLever5.visible = false
		#$LeftLever5.visible = true
		$BridgeExtends/Sprite.visible = false
		$BridgeExtends/Sprite2.visible = true
		#Utility.bridgeAnim=true
		loadBridge("Ponte")
		
		if not Utility.bridgeAnim[5]:
			$Bridge1/Camera2D.current = true
		else:
			$Player/Camera2D.current = true
			for i in range(1, nBridge+1):
				var bridgeSec = get_node("Bridge"+str(i))
				bridgeSec.get_child(1).set_deferred("disabled", false)
				bridgeSec.visible=true
			get_node_or_null("/root/Livello5/Ponte").queue_free() #FONDAMENTALE!!!
			#EVITA PROBLEMI DI COLLISIONE CON LE PIATTAFORME
			Utility.bridgeAnim[5] = false
	
	if Utility.leverOn[6]:
		
		#$RightLever6.visible = false
		#$LeftLever6.visible = true
		$BridgeRemove/Sprite.visible = false
		$BridgeRemove/Sprite2.visible = true
		
		if not Utility.bridgeAnim[6]:
			$Bridge9/Camera2D.current = true
			$Bridge9/Animation.start()
			print("Start Animation"+str($Bridge9/Animation.time_left))
			Utility.bridgeAnim[6] = true
			
		if get_node_or_null("Bridge9/Animation") and $Bridge9/Animation.time_left==0:
			print("End Animation")
			$Bridge9.visible = false
			$Bridge9.set_deferred("disabled", true)
			$Bridge9.visible = false
			$Bridge9.queue_free()
			#Utility.leverOn[6] = false
			$Player/Camera2D.current = true
				#removeBridge("Ponte")
				
	#fire detection
	if Input.is_key_pressed(KEY_E) and $Player/BulletCoolDown.time_left==0:
		var fireScene = load("res://Fire.tscn");
		var fireNode = fireScene.instance();
		fireNode.position = $Player.position-Utility.bulletPose+Utility.bulletDist*Utility.bulletVelocity[Utility.lastDirection];
		#fireNode.position = $Player.position+Utility.bulletDist*Utility.bulletVelocity[Utility.lastDirection];
		add_child(fireNode)
		#get_node("/root/Livello4").add_child(shoesNode);
		$Player/BulletCoolDown.start()	
		
	
	if Utility.brokenGround:
		Utility.brokenGround = false
		for i in range(7, 18):
			var brokenNode = get_node_or_null("BrokenWall"+str(i))
			if brokenNode: 
				Utility.lastPoseBrokenWall = brokenNode.position
				brokenWall("MuroRotto")
				brokenNode.queue_free()
		if get_node_or_null("MovingBox"): $MovingBox.queue_free()
		
	if Utility.extendsStair1:
		Utility.extendsStair1 = false
		$Stair43.visible = true
		$Stair44.visible = true
		$ExtendsStair1/Sprite.visible = false
		$ExtendsStair1/Sprite2.visible = true
		$ExtendsStair1/Timer.start()
		
	if Utility.extendsStair2:
		Utility.extendsStair2 = false
		$ExtendsStair2/Sprite.visible = false
		$ExtendsStair2/Sprite2.visible = true
		$ExtendsStair2/Timer.start()
		for i in [41, 53, 48, 49, 54, 55]:
			get_node_or_null("Stair"+str(i)).visible = true
			
		$Door3/StaticBody2D/CollisionShape2D.disabled=true
		$Door3.visible=false
		loadDoor("Porta", $Door3.position, true)
		
	if Utility.lastKeyTaken and get_node_or_null("LastKey"):
		Utility.lastKeyTaken = false
		#$LastKey.visible = true
		$LastKey/Timer.start()
		Utility.lastKeyRemove = true
		$LastKey/Sprite.visible = true
		$LastKey/CollisionShape2D.disabled = false
	
	
	if Utility.lastKeyRemove and get_node_or_null("LastKey") and $LastKey/Timer.time_left == 0:
		Utility.lastKeyRemove = false
		$LastKey.queue_free()
	
			#for i in range(1, nBridge+1):
			#	var bridgeSec = get_node("Bridge"+str(i))
			#	bridgeSec.get_child(1).set_deferred("disabled", false)
			#	bridgeSec.visible=true
		
		
	
	
#end function process

func _on_Pause_pressed():
	pass # Replace with function body.


func _on_Exit_pressed():
	Utility.inGame=false
	set_process(false)
	set_physics_process(false)
	var nodes = get_children()
	for n in nodes:
		if "RigidBody2D" in str(n):
			n.sleeping=true
	
	#$CanvasLayer/Alert.set_position(Utility.playerPose)#+Vector2(600, 200))
	#$CanvasLayer/Alert.popup()
	$CanvasLayer/Alert.popup_centered()
	print(Utility.playerPose)
	#$Alert.popup(Rect2(Vector2(Utility.playerPose), Vector2(1500,1500)))
	#$Alert.popup_centered()
	#$Alert.add_button("Cancel",false,"cancelled")
	#SceneManager.goto_scene("res://Home.tscn")


func _on_Alert_confirmed():
	SceneManager.goto_scene("res://Home.tscn")
	
func cancelled():
	Utility.inGame=true
	set_process(true)
	set_physics_process(true)
	var nodes = get_children()
	for n in nodes:
		if "RigidBody2D" in str(n):
			n.sleeping=false
			n.angular_velocity = 10

func _on_Player_enemyCollision():
	Utility.lifes-=1

func loadKey(name, keyPose, left):
		var keyScene = load("res://"+name+".tscn");
		var keyNode = keyScene.instance();
		keyNode.position = keyPose;
		#adjust scaling factor of the shoes in the scene (and the collision shapes)
		keyNode.get_child(0).scale *= Utility.scaling
		keyNode.get_child(0).flip_v = left
		#keyNode.get_child(1).scale *= Utility.scaling
		
		get_node("/root/Livello5").add_child(keyNode);
			#_count +=1;

func loadDoor(name, doorPose, left):
		var doorScene = load("res://"+name+".tscn");
		var doorNode = doorScene.instance();
		doorNode.position = doorPose;
		#adjust scaling factor of the shoes in the scene (and the collision shapes)
		doorNode.get_child(0).scale *= Utility.scaling*4
		doorNode.get_child(0).flip_v = left
		#keyNode.get_child(1).scale *= Utility.scaling
		
		get_node("/root/Livello5").add_child(doorNode);
			#_count +=1;
			
			
func loadBridge(name):#, bridgePose):
		
		var bridgeScene = load("res://"+name+".tscn")
		var bridgeNode = bridgeScene.instance()
		bridgeNode.position = get_node_or_null("Bridge1").position
		
		#adjust scaling factor of the shoes in the scene (and the collision shapes)
		#bridgeNode.get_child(0).scale *= Utility.scaling*4
		#bridgeNode.get_child(0).flip_v = left
		#keyNode.get_child(1).scale *= Utility.scaling
		
		get_node("/root/Livello5").add_child(bridgeNode);
			#_count +=1;

func brokenWall(name):#, bridgePose):
	
	var wallScene = load("res://"+name+".tscn")
	var wallNode = wallScene.instance()
	#wallNode.position = Vector2(3692, -1369)
	wallNode.position = Utility.lastPoseBrokenWall #brokenWallPose
	
	get_node("/root/Livello5").add_child(wallNode);
	
func removeBridge(name):#, bridgePose):
		
		pass
		#var bridgeScene = load("res://"+name+".tscn");
		#var bridgeNode = bridgeScene.instance();
		#bridgeNode.position = get_node_or_null("Bridge1").position
		
		#adjust scaling factor of the shoes in the scene (and the collision shapes)
		#bridgeNode.get_child(0).scale *= Utility.scaling*4
		#bridgeNode.get_child(0).flip_v = left
		#keyNode.get_child(1).scale *= Utility.scaling
		
		#get_node("/root/Livello5").add_child(bridgeNode);
			#_count +=1;

func loadStair(stopIndex):
	animCount += 1
	if $StairAnimation.time_left > 0 and stairCount <= stopIndex and animCount%1000<10:
		get_node_or_null("Stair"+str(stairCount)).visible = true
		stairCount += 1
