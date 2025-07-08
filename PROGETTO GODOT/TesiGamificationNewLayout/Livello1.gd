extends Node2D

var spawnVelocity = 25; #50 1 shoe every 50 frame
var spawnTimer = 0;
var shoesName = ["ScarpaVerde", "ScarpaRossa", "ScarpaNera", "ScarpaBlu"];
var randShoes=0;
var _count = 1;
var lifes = 5;

var deltaTime = 0;
#var seconds = 0
#var minutes = 0
#var hours = 0
var shoesToWin = 30

#var inGame = false;

var shoesGreen=0;
var winornot = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.scale = Utility.scaling
	Utility.inGame=false
	
	$Cesto2D.visible=false
	$Forziere.visible=false
	$Moneta.visible=false
	$Monete.visible=false
	$Vita1.visible=false
	$Vite.visible=false
	$Tempo.visible=false
	$Top_Menu_Bar.visible=false
	$Exit.visible=false
	$Pause.visible=false
	
	
	$Alert.get_cancel().connect("pressed", self, "cancelled")
	#$GameInfo.popup()
	$Intro.popup_centered()
	
	Utility.coinsPose = $Monete.rect_position
	#for i in range(1, lifes+1):
	#	get_node("Vita"+str(i)).visible=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Pause.focus_mode = Control.FOCUS_NONE
	$Exit.focus_mode = Control.FOCUS_NONE
	
	self.scale = Utility.scaling
	
	if Utility.inGame:
		spawnTimer += 1;
		if spawnTimer>spawnVelocity:
			spawnTimer = 0;
			randomize();
			var initPose = Vector2(50 + randi()%960, -130.0);
			randShoes = (randShoes+1)%len(shoesName);
			var name = shoesName[randShoes];
			loadShoes(name, initPose);
	
	
		#test move scene		
		#if Input.is_key_pressed(KEY_C):
		#print("premuto C");
		#SceneManager.goto_scene("res://ScarpaNera.tscn");
	
		Utility.updateTime(delta)
		$Tempo.text=str(Utility.timeCalculate(Utility.seconds)[0])+":"+str(Utility.timeCalculate(Utility.seconds)[1])+":"+str(Utility.timeCalculate(Utility.seconds)[2])
		#$Tempo.text=str(Utility.timeCalculate(seconds)[0])+":"+str(Utility.timeCalculate(seconds)[1])+":"+str(Utility.timeCalculate(seconds)[2])
	
	
		#if($TimerGameOver.time_left==0) and lifes>0:
		#	$TimerGameOver.start()
	
	if Utility.inGame:
		$TimerGameOver.start()
		
	if lifes<1: 
		show_game_over()
		Utility.inGame = false;
		#set_process(false)
		#if $Cesto2D: $Cesto2D.queue_free()
		$SegnoX.visible=false
		$Cesto2D.visible=false
		
		if ($TimerGameOver.time_left==0):
			$Cesto2D/CollisionShape2D.disabled=true
			$Home.visible=true
			$Ricomincia.visible=true
	
	if shoesGreen>=shoesToWin:
		winornot=true
		show_winner()
		Utility.inGame=false;
		$SegnoX.visible=false
		$Cesto2D.visible=false
		if ($TimerGameOver.time_left==0):
			$Cesto2D/CollisionShape2D.disabled=true
			#$Home.visible=true
			
		
	
	#debug function
	if Input.is_key_pressed(KEY_M) and Utility.debug:
		print(Utility.basketAcc)
		#$Outro.popup_centered()
	
#func updateTime(delta):
#	deltaTime += delta
#	if deltaTime>=1 : 
#		seconds+=1
#		deltaTime=0
	#if seconds>=60:
	#	minutes+=1
	#	seconds=0
	#if minutes>=60:
	#	hours+=1
	#	minutes=0;
		
func loadShoes(name, pose):
		var shoesScene = load("res://"+name+".tscn");
		var shoesNode = shoesScene.instance();
		#var node = shoesNode.get_node("/root/Scarpe/ScarpaVerde");
		#var shoesNode = $ScarpaRossa;
		#var shoesNode = get_node("/root/Main/"+name);
		#if shoesNode:  
		#var shoesNode = get_node("/root/Scarpe/"+name)
		#shoesNode = shoesNode.get_child(0);
		#shoesNode = shoesNode.get_node(name);
			#var shoesNodeClone = shoesNode.duplicate(15);
			#shoesNodeClone.name += str(_count);
		shoesNode.position = pose;
		#adjust scaling factor of the shoes in the scene (and the collision shapes)
		shoesNode.get_child(0).scale *= Utility.scaling
		shoesNode.get_child(1).scale *= Utility.scaling
		
		get_node("/root/Livello1").add_child(shoesNode);
			#_count +=1;
			
func _on_Cesto2D_shoesRed_taken():
	
	var _lifeNode;
	if ($TimerLifes.time_left==0):
		$TimerLifes.start();
		
		$SegnoX.visible=true;
		$TimerX.start();
		#$SegnoX.visible=false;
		
		#lifeNode = find_node("Vita"+str(lifes));
		#if lifeNode: lifeNode.queue_free();
		if Utility.inGame:
			lifes -= 1;
			$Vite.text = str(lifes)
		
		$SegnoX.position = $Cesto2D.position + Vector2(515,568);
		#print($SegnoX.position);
		

func _on_Cesto2D_shoesGreen_taken(points):
	shoesGreen+=1;
	$Monete.text = str(points)
	

func show_game_over():
	$GameOver.visible = true
	$GameOver.text = "YOU LOSE"

func show_winner():
	$Outro.popup_centered()
	var nodes = get_children()
	for n in nodes:
		if "RigidBody2D" in str(n):
			n.sleeping=true
	#$GameOver.visible = true
	#$GameOver.text = "YOU WIN"

func _on_Home_pressed():
	if winornot: 
		RoomsManager.levels+=1
		RoomsManager.points+=int($Monete.text)
		RoomsManager.seconds+=Utility.seconds
		RoomsManager.lifes=lifes
		RoomsManager.saveEnviroment()
		#print(RoomsManager.levels)
	SceneManager.goto_scene("res://Home.tscn")


func _on_Ricomincia_pressed():
	SceneManager.goto_scene("res://Livello1.tscn")


func setVisible():
	$Cesto2D.visible=true
	#$Forziere.visible=true
	$Moneta.visible=true
	$Monete.visible = true
	$Tempo.visible=true
	$Vita1.visible=true
	$Vite.text = str(lifes)
	$Vite.visible=true
	$Top_Menu_Bar.visible=true
	$Exit.visible=true
	$Pause.visible=true
	
	#for i in range(1, lifes+1):
		#get_node("Vita"+str(i)).visible=true
	
#func _on_GameInfo_confirmed():
	#Utility.inGame=true
	#setVisible()
	


func _on_Alert_confirmed():
	#if winornot: 
	#	RoomsManager.levels+=1
	#	RoomsManager.points+=int($Monete.text)
	#	RoomsManager.seconds+=Utility.seconds
	#	RoomsManager.lifes=lifes
	#	RoomsManager.saveEnviroment()
	SceneManager.goto_scene("res://Home.tscn")


func _on_Exit_pressed():
	Utility.inGame=false
	set_process(false)
	set_physics_process(false)
	var nodes = get_children()
	for n in nodes:
		if "RigidBody2D" in str(n):
			n.sleeping=true
	
	#$Alert.popup()
	$Alert.popup_centered()


func _on_Pause_pressed():
	if (Utility.pauseStart % 2 == 0):
		#$Pause.text="GIOCA"
		Utility.inGame=false
		set_process(false)
		set_physics_process(false)
		var nodes = get_children()
		for n in nodes:
			if "RigidBody2D" in str(n):
				n.sleeping=true
				#n.queue_free()
		$Pause.icon = load("res://1 - gioco cestino/icona_riprendi.png")
		
	else:
		#$Pause.text="PAUSA"
		Utility.inGame=true
		set_process(true)
		set_physics_process(true)
		var nodes = get_children()
		for n in nodes:
			if "RigidBody2D" in str(n):
				n.sleeping=false
				n.angular_velocity = 10
		$Pause.icon = load("res://1 - gioco cestino/icona_pausa.png")
		
	Utility.pauseStart += 1

#improve button presssed
func _input(event):
	if event is InputEventMouseButton:
		#print("click")
		if event.position.distance_to($Exit.rect_position)<20*Utility.eps:
			#print("tasto premuto")
			_on_Exit_pressed()
		if event.position.distance_to($Pause.rect_position)<20*Utility.eps:
			_on_Pause_pressed()


func cancelled():
	print("CANCELLED CALL")
	Utility.inGame=true
	set_process(true)
	set_physics_process(true)
	var nodes = get_children()
	for n in nodes:
		if "RigidBody2D" in str(n):
			n.sleeping=false
			n.angular_velocity = 10


func _on_Inizia_pressed():
	Utility.inGame=true
	setVisible()
	$Intro.queue_free()


func _on_Esci_pressed():
	SceneManager.goto_scene("res://Home.tscn")


func _on_Continua_pressed():
	RoomsManager.updateState(1, int($Monete.text), Utility.seconds, RoomsManager.lifes)
	SceneManager.goto_scene("res://Home.tscn")
