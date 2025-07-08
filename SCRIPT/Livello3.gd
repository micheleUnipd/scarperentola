extends Node2D

var direction = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var angles = [0, 1.57, 3.14, 4.71]
#var velocity = [Vector2(1,0),Vector2(0,-1),Vector2(-1,0),Vector2(0,1)]
var velocity = [Vector2(1,0),Vector2(0,1),Vector2(-1,0),Vector2(0,-1)]
var timer = 0
var timeChange = 10
var randIndex = 0

#var timerStart=0
var inGame = false

var coinTime = 0
#signal enemyKilled

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var topMenuNode = get_node_or_null("CanvasLayer")
	topMenuNode.scale = Utility.scaling
	#for i in range(0, topMenuNode.get_child_count()):
	#	topMenuNode.get_child(i).scale = Utility.scaling
		#topMenuNode.scale = Utility.scaling
	
	Utility.inGame = false
	
	$CanvasLayer/Forziere.visible=false
	$CanvasLayer/Top_Menu_Bar.visible=false
	$CanvasLayer/Tempo.visible=false
	$CanvasLayer/Vita1.visible=false
	$CanvasLayer/Vite.visible=false
	$CanvasLayer/Moneta.visible=false
	$CanvasLayer/Monete.visible=false
	$CanvasLayer/Exit.visible=false
	$CanvasLayer/Pause.visible=false
	$CanvasLayer/Mappa.visible=false
	
	$CanvasLayer/Alert.get_cancel().connect("pressed", self, "cancelled")
	#$GameInfo.popup_centered()
	$Intro.popup_centered()
	
	Utility.lifes = RoomsManager.lifes
	#for i in range(1, RoomsManager.maxLifes+1):
	#	get_node("CanvasLayer/Vita"+str(i)).visible=false

func selectDir(i):
	randIndex = randi()%len(angles)
	#print(randIndex)
	#print("Valore indice: "+str(i))
	var enemyNode = get_node_or_null("Enemy"+str(i+1)+"/AnimatedSprite")
	if enemyNode!=null: 
		enemyNode.rotation_degrees = 0
	#get_node("Enemy"+str(i+1)+"/Sprite").rotate(-1*angles[direction[randIndex]])
	
		if randIndex == 2: 
		#if enemyNode!=null: enemyNode.texture = load("res://FlappyBirdReversed.png")
		#if enemyNode!=null: 
			if Utility.animationActive: 
				enemyNode.play("walk_left")
				enemyNode.flip_h = true
			
		elif randIndex == 3:
		#if enemyNode!=null:
			if Utility.animationActive: enemyNode.play("walk_up")
	
		elif randIndex == 0:
		#if enemyNode!=null:
			if Utility.animationActive:
				enemyNode.play("walk_left")
				enemyNode.flip_h = false
	
		elif randIndex == 1:
		#if enemyNode!=null:
			if Utility.animationActive:
				enemyNode.play("walk_down")
	
	direction[i]=randIndex
	#else:
	#	if enemyNode!=null:
	#		enemyNode.texture = load("res://FlappyBird.png")
	#		enemyNode.rotate(angles[direction[i]])
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#solve the space bar problem with the buttons
	$CanvasLayer/Mappa.focus_mode = Control.FOCUS_NONE
	$CanvasLayer/Pause.focus_mode = Control.FOCUS_NONE
	$CanvasLayer/Exit.focus_mode = Control.FOCUS_NONE
	
	if Utility.inGame:
		Utility.updateTime(delta)
		var time = Utility.timeCalculate(Utility.seconds)
		$CanvasLayer/Tempo.text = str(time[0])+":"+str(time[1])+":"+str(time[2])
		#timerStart += delta
	
		#update points in the top bar menu
		$CanvasLayer/Monete.text = str(Utility.points)
		timer += delta
		for i in range(len(direction)):
			#print(len(direction))
			if timer > timeChange:
				timer = 0
				selectDir(i)
			
			else:
				
				var enemyNode = get_node_or_null("Enemy"+str(i+1))
				if not Utility.animationActive and enemyNode!=null: enemyNode.get_child(1).play("stand_down")
				if enemyNode!=null: 
					var collision = enemyNode.move_and_collide(velocity[direction[i]].normalized()*delta*Utility.enemyAcc)
					#if collision: print(collision.collider.name)
					if collision:
						if "TileMap" in collision.collider.name or "Enemy" in collision.collider.name or "Exit" in collision.collider.name:
							#print(collision.collider.name)
							selectDir(i)
						#if "Fire" in collision.collider.name:
							#enemyNode.queue_free()
						#	enemyNode.free()
						#	print(collision.collider.name)
						#	collision.collider.free()
						#	emit_signal("enemyKilled")
							
	
	if Input.is_key_pressed(KEY_SPACE) and $Player/BulletCoolDown.time_left==0:
		var fireScene = load("res://Fire.tscn");
		var fireNode = fireScene.instance();
		fireNode.position = $Player.position-Utility.bulletPose+Utility.bulletDist*Utility.bulletVelocity[Utility.lastDirection];
		#fireNode.position = $Player.position+Utility.bulletDist*Utility.bulletVelocity[Utility.lastDirection];
		add_child(fireNode)
		#get_node("/root/Livello4").add_child(shoesNode);
		$Player/BulletCoolDown.start()
	
	
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
		
	
	if Utility.enemyKilled:
		Utility.enemyKilled = false
		$CoinAnimation.start()
	
	#debug test of funtionality
	#if Input.is_key_pressed(KEY_M):
		#Utility.lifes = 0
		#$CanvasLayer/GameOverTemp.popup_centered()
		#test anything
	
	#Utility.coinsPose = $CanvasLayer/Monete.get_global_rect()
	if Utility.lifes==0:
		Utility.inGame = false
		set_process(false)
		set_physics_process(false)
		var nodes = get_children()
		for n in nodes:
			if "Enemy" in str(n):
				n.sleeping=true
		
		
		$CanvasLayer/GameOver.popup()
		#$CanvasLayer/Home.rect_position = $Player.position + Vector2(310, 250)
		#$CanvasLayer/Home.visible = true
		#$CanvasLayer/GameOver.rect_position = $Player.position + Vector2(250, 100)
		#$CanvasLayer/GameOver.text = "YOU LOSE"
		#$CanvasLayer/GameOver.visible = true
		#$CanvasLayer/GameOver.popup_centered()
	
	if Input.is_key_pressed(KEY_M) and Utility.debug:
		
		$CanvasLayer/Outro.popup()
		#Utility.lifes = 0
	
func setVisible():
	#$CanvasLayer/Forziere.visible=true
	$CanvasLayer/Top_Menu_Bar.visible=true
	$CanvasLayer/Tempo.visible=true
	$CanvasLayer/Vita1.visible=true
	$CanvasLayer/Vite.visible=true
	$CanvasLayer/Moneta.visible=true
	$CanvasLayer/Monete.visible=true
	$CanvasLayer/Exit.visible=true
	$CanvasLayer/Pause.visible=true
	$CanvasLayer/Mappa.visible=true
	
	$CanvasLayer/Vite.text = str(Utility.lifes)
	#for i in range(1, RoomsManager.lifes+1):
	#	get_node("CanvasLayer/Vita"+str(i)).visible=true


func updateLifes():
	$CanvasLayer/Vite.text = str(Utility.lifes)
	#for i in range(RoomsManager.maxLifes, RoomsManager.lifes, -1):
	#	get_node("CanvasLayer/Vita"+str(i)).visible=false

func _on_AcceptDialog_confirmed():
	
	#for i in range(0, 1000):
		#if timerStart>2:
	#		$GameInfo.rect_scale -= Vector2(0.1, 0.1)
	#		$GameInfo.rect_position += Vector2(0.1, 0.1)
			#timerStart = 0
	#$GameInfo.size.x *= 0.5
	#$GameInfo.size.y *= 0.5
	
	Utility.inGame = true
	get_node("Player/Camera2D").current = true
	setVisible()
	
	#startin animation for all the enemy
	for i in range(0, len(direction)):
		var enemyNode = get_node_or_null("Enemy"+str(i)+"/AnimatedSprite")
		if enemyNode: enemyNode.playing = true
		
	
func _on_Player_enemyCollision():
	Utility.lifes-=1
	updateLifes()


#func _on_Livello4_enemyKilled():
#	var coinScene = load("res://MonetaOro4.tscn");
#	var coinNode = coinScene.instance();
#	$CanvasLayer/Monete.text = str(int($CanvasLayer/Monete.text)+30)
#	coinNode.position = $Player.position#-Utility.bulletPose#+Utility.bulletDist*Utility.bulletVelocity[Utility.lastDirection];
#	add_child(coinNode)
	


func _on_Pause_pressed():
	if (Utility.pauseStart % 2 == 0):
		#$Pause.text="GIOCA"
		Utility.inGame=false
		set_process(false)
		set_physics_process(false)
		var nodes = get_children()
		for n in nodes:
			if "Enemy" in str(n):
				n.sleeping=true
				#n.queue_free()
		$CanvasLayer/Pause.icon = load("res://1 - gioco cestino/icona_riprendi.png")
	else:
		#$Pause.text="PAUSA"
		Utility.inGame=true
		set_process(true)
		set_physics_process(true)
		var nodes = get_children()
		for n in nodes:
			if "Enemy" in str(n):
				n.sleeping=false
				#n.angular_velocity = 10
		$CanvasLayer/Pause.icon = load("res://1 - gioco cestino/icona_pausa.png")
	Utility.pauseStart += 1


func _on_Exit_pressed():
	
	Utility.inGame=false
	set_process(false)
	set_physics_process(false)
	var nodes = get_children()
	for n in nodes:
		if "Enemy" in str(n):
			n.sleeping=true
		
	#$Alert.popup_centered()
	$CanvasLayer/Alert.popup()
	

func _on_Alert_confirmed():
	SceneManager.goto_scene("res://Home.tscn")
	
	
func _on_Mappa_pressed():
	
	Utility.inGame=false
	set_process(false)
	set_physics_process(false)
	var nodes = get_children()
	for n in nodes:
		if "Enemy" in str(n):
			n.sleeping=true
			
	#$CanvasLayer/Maps.popup_centered()
	$CanvasLayer/Maps.popup()
	
func cancelled():
	Utility.inGame=true
	set_process(true)
	set_physics_process(true)
	var nodes = get_children()
	for n in nodes:
		if "Enemy" in str(n):
			n.sleeping=false
			n.angular_velocity = 10


func _on_Maps_confirmed():
	Utility.inGame=true
	set_process(true)
	set_physics_process(true)
	var nodes = get_children()
	for n in nodes:
		if "Enemy" in str(n):
			n.sleeping=false


func _on_Home_pressed():
	SceneManager.goto_scene("res://Home.tscn")


func _on_Inizia_pressed():
	Utility.inGame = true
	get_node("Player/Camera2D").current = true
	setVisible()
	
	#startin animation for all the enemy
	for i in range(0, len(direction)):
		var enemyNode = get_node_or_null("Enemy"+str(i)+"/AnimatedSprite")
		if enemyNode: enemyNode.playing = true
	
	$Intro.queue_free()

func _on_Esci_pressed():
	SceneManager.goto_scene("res://Home.tscn")


func _on_Continua_pressed():
	#RoomsManager.levels+=1
	#RoomsManager.points+=int($CanvasLayer/Monete.text)
	#RoomsManager.seconds+=seconds;
	
	RoomsManager.updateState(3, int($CanvasLayer/Monete.text), Utility.seconds, RoomsManager.lifes)
	RoomsManager.saveEnviroment()
	SceneManager.goto_scene("res://Home.tscn")
