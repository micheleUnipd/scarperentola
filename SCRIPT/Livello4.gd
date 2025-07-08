extends Node2D
var selected;
var index=0;

var rightPoses = [Vector2(225, 175), Vector2(367, 175), Vector2(225, 257), Vector2(367, 257), Vector2(225, 341), Vector2(367, 341)]
var initialPoses = []
var rightFragment = []

#var inGame = false
var coinTime = 0

func _input(event):
   
	var fragment;
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		for i in range(1,7):
				fragment = get_node("Sandalo_"+str(i))
				if fragment.position.distance_to(event.position)<10*Utility.eps:
					selected = fragment;
					index = i-1
					print(selected.name)
					print(index)
					return
					
		#print("Mouse Click/Unclick at: ", event.position)
		#if event.position.distance_squared_to($Sprite.position)<Utility.eps:
	elif event is InputEventMouseMotion:
	#print("Mouse Motion at: ", event.position)
		if selected and Input.is_mouse_button_pressed(1):
			selected.position = event.position
		elif selected and selected.position.distance_to(rightPoses[index])<10*Utility.eps:
			selected.position = rightPoses[index]
			if not str(index) in rightFragment: rightFragment.append(str(index))
			print(rightFragment)
			#Utility.loadCoin("Livello4", position)
			$CoinAnimation.start()
			$Monete.text = str(int($Monete.text) + 10)
			selected = null
		elif selected:
			selected.position = initialPoses[index]
			selected = null
		#else: selected = null
			
		#if Input.is_mouse_button_pressed(1) and Utility.inGame(event.position.x, event.position.y): 
		#	$Sandalo.position = event.position
		
   # Print the size of the viewport.
   #print("Viewport Resolution is: ", get_viewport_rect().size)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Forziere.visible=false
	$Top_Menu_Bar.visible=false
	$Tempo.visible=false
	$Vita1.visible=false
	$Vite.visible=false
	$Moneta.visible=false
	$Monete.visible=false
	$Exit.visible=false
	$Pause.visible=false
	
	$GameInfo.popup_centered()
	
	#for i in range(1, Utility.lifes+1):
	#	get_node("Vita"+str(i)).visible=false
	for i in range(1, 7):
		initialPoses.append(get_node("Sandalo_"+str(i)).position)
	print(initialPoses)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Utility.inGame:
		Utility.updateTime(delta)
		$Tempo.text=str(Utility.timeCalculate(Utility.seconds)[0])+":"+str(Utility.timeCalculate(Utility.seconds)[1])+":"+str(Utility.timeCalculate(Utility.seconds)[2])
		#$Tempo.text="00:00:32"
		if len(rightFragment)==6:
			$Vittoria.visible=true
			$Vittoria.text = "YOU WIN !!!"
			$Prosegui.visible=true
	
		if $CoinAnimation.time_left>0:
			$Moneta.rotate(0.5)
			coinTime += 1
			if coinTime%10 < 5:
				$Monete.visible = true
			else:
				$Monete.visible = false
			
		else:
			if Utility.inGame: $Monete.visible = true
			$Moneta.rotation_degrees = 0
			
		
func setVisible():
	
	$Top_Menu_Bar.visible=true
	$Tempo.visible=true
	$Vita1.visible=true
	$Vite.visible=true
	$Moneta.visible=true
	$Monete.visible=true
	$Exit.visible=true
	$Pause.visible=true
	
	#for i in range(1, Utility.lifes+1):
	#	get_node("Vita"+str(i)).visible=true

func _on_GameInfo_confirmed():
	Utility.inGame=true
	setVisible()


func _on_Prosegui_pressed():
	
	#if RoomsManager.levels<RoomsManager.maxLevels: RoomsManager.levels+=1
	RoomsManager.updateState(4, int($Monete.text), Utility.seconds, RoomsManager.lifes)
	#RoomsManager.points+=int($Monete.text)
	#RoomsManager.seconds+=seconds;
	RoomsManager.saveEnviroment()
	SceneManager.goto_scene("res://Home.tscn")


func _on_Pause_pressed():
	if (Utility.pauseStart % 2 == 0):
		#$Pause.text="GIOCA"
		Utility.inGame=false
		set_process(false)
		$Pause.icon = load("res://1 - gioco cestino/icona_riprendi.png")
	else:
		#$Pause.text="PAUSA"
		Utility.inGame=true
		set_process(true)
		$Pause.icon = load("res://1 - gioco cestino/icona_pausa.png")
	Utility.pauseStart += 1


func _on_Exit_pressed():
	$Alert.popup_centered()
	
func _on_Alert_confirmed():
	SceneManager.goto_scene("res://Home.tscn")
