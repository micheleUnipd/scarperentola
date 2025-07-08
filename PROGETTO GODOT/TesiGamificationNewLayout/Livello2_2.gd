extends Node2D
var selected;
var index=0;

var winOrNot = false
#var inGame = false

var nRows = 5
var nCols = 5
var xDist = 147
var yDist = 88

var sudokuSolve = [[1, 2, 3, 4, 5], [2, 4, 5, 1, 3], [3, 1, 4, 5, 2], [5, 3, 1, 2, 4], [4, 5, 2, 3, 1]]
var shoesOrder = ["Sandalo", "Poulaine", "Cioppina", "SapraScarpa", "Invisibile"]
var sudokuCurr = [["Sandalo","","","",""],["","","","","Cioppina"],["","","SapraScarpa","",""],["","","","Poulaine",""],["","Invisibile","","",""]]
var shoesTaken = [1, 1, 1, 1, 1]

#var rightPoses = [Vector2(225, 175), Vector2(367, 175), Vector2(225, 257), Vector2(367, 257), Vector2(225, 341), Vector2(367, 341)]
var initialPoses = []
var rightFragment = []

var animationCont = 0


func selectShoesVisible():
	
	var permutations = Utility.permutations("01234")
	var colsSelected = []
	
	var r = 0
	#var c = 0
	var shoesSelected = ""
	for s in permutations:
		r=0
		shoesSelected = ""
		for j in s:
			shoesSelected += sudokuSolve[r][int(j)]
			r+=1
		if len(Utility.removeDuplicates(shoesSelected))==len(shoesSelected):
				#print(shoesSelected)
				for c in s:
					colsSelected.append(int(c))
				#return(shoesSelected)
				return colsSelected
				

	
func createSchema():
	
	sudokuSolve = Utility.changeFormat(Utility.createSudokuSchema(5))
	
	var colsSelected = selectShoesVisible()
	
	sudokuCurr = []
	var temp = []
	for i in range(0, nRows):
		temp = []
		for j in range(0, nCols):
				if colsSelected[i]==j:#(int(sudokuSolve[i][j])):
					temp.append(shoesOrder[int(sudokuSolve[i][j])-1])
					#allSchema += str(sudokuSolve[i][j])
				else:
					temp.append("")
		sudokuCurr.append(temp)
	
	var currX = 222
	var currY = 167
	for i in range (0, nRows):
		for j in range (0, nCols):
			if len(sudokuCurr[i][j])>0:
				#print(sudokuCurr[i][j])
				get_node_or_null(sudokuCurr[i][j]+"5").position = Vector2(currX, currY)
			currX += xDist
		currY += yDist
		currX = 222
				
	print(sudokuSolve)
	print(sudokuCurr)
	

func _input(event):
   
	var shoesNode;
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		
		for j in range(1, nCols):
			for i in range(1, len(shoesOrder)+1):
				shoesNode = get_node_or_null(shoesOrder[i-1]+str(j))#+str(shoesTaken[i-1]))
				if shoesNode!=null and shoesNode.position.distance_to((event.position)/Utility.scaling)<10*Utility.eps:
					selected = shoesNode;
					index = i-1
					#print(selected.name)
					#print(index)
					return
					
		#for i in range(0, nRows):
		#	for j in range(0, nCols):
		#		shoesNode = get_node_or_null(shoesOrder[])
					
					
		#print("Mouse Click/Unclick at: ", event.position)
		#if event.position.distance_squared_to($Sprite.position)<Utility.eps:
	elif event is InputEventMouseMotion:
	#print("Mouse Motion at: ", event.position)
		if selected and Input.is_mouse_button_pressed(1):
			selected.position = event.position/Utility.scaling
		
		elif selected:
			var currX = 222
			var currY = 167
			var rightPose
			var stopCond = false
			
			for i in range (0, nRows):
				for k in range (0, nCols):
					if selected.position.distance_to(Vector2(currX, currY))<10*Utility.eps:
						rightPose = Vector2(currX, currY)
						stopCond = true
						sudokuCurr[i][k] = selected.name
						#print(sudokuCurr)
						break 
					currX += xDist
				currY += yDist
				currX = 222
				if stopCond: break
					
			if selected and stopCond: selected.position = rightPose
			#if not str(index) in rightFragment: rightFragment.append(str(index))
			#print(rightFragment)
			#Utility.loadCoin("Livello2", position)
			#$Punti.text = str(int($Punti.text) + 10)
			#print("Rilascio scarpa")
			shoesTaken[index] += 1
		#	selected.position = initialPoses[index]
			if selected and not stopCond:
				#print("Position not found")
				#print(selected.name)
				for i in range(0, len(shoesOrder)):
					if selected.name.substr(0,len(selected.name)-1) in shoesOrder[i]:
						selected.position = initialPoses[i]
				#select.name
			selected = null
		#else: selected = null
			
		#if Input.is_mouse_button_pressed(1) and Utility.inGame(event.position.x, event.position.y): 
		#	$Sandalo.position = event.position
	
   # Print the size of the viewport.
   #print("Viewport Resolution is: ", get_viewport_rect().size)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	createSchema()
	
	$Pause.focus_mode = Control.FOCUS_NONE
	$Exit.focus_mode = Control.FOCUS_NONE
	self.scale = Utility.scaling
	
	for i in range(1, len(shoesOrder)+1):
		initialPoses.append(get_node(shoesOrder[i-1]+"1").position)
	#print(initialPoses)
	
	#$Punti.visible = false
	$Forziere.visible=false
	$Top_Menu_Bar.visible=false
	$Tempo.visible=false
	$Vita1.visible=false
	$Vite.visible=false
	$Moneta.visible=false
	$Monete.visible=false
	$Exit.visible=false
	$Pause.visible=false
	$Verifica.visible=false
	$Griglia.visible=false
	
	for i in range(0, len(shoesOrder)):
		get_node_or_null(shoesOrder[i]+"5").visible = false
		print(shoesOrder[i]+"5")
		
	Utility.coinsPose = $Monete.rect_position
	
	$Alert.get_cancel().connect("pressed", self, "cancelled")
	#$GameInfo.popup()
	$Intro.popup_centered()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	self.scale = Utility.scaling
	
	if Utility.inGame:
		Utility.updateTime(delta)
		$Tempo.text=str(Utility.timeCalculate(Utility.seconds)[0])+":"+str(Utility.timeCalculate(Utility.seconds)[1])+":"+str(Utility.timeCalculate(Utility.seconds)[2])
		#$Tempo.text="00:00:30"
		
	if winOrNot:
		$Griglia.modulate = Color(0,1,0)
		$Outro.popup()
		#$Vittoria.visible=true
		#$Vittoria.text = "YOU WIN !!!"
		#$Home.visible=true
	
	animationCont+=1
	if $TimerWrong.time_left>0:
		if animationCont%10<7:
			$Griglia.modulate = Color(1,0,0)
		else:
			$Griglia.modulate = Color(1,1,1)
	
	if $TimerWrong.time_left==0 and not winOrNot:
		$Griglia.modulate = Color(1,1,1)
		
	
	if Input.is_key_pressed(KEY_M) and Utility.debug:
		$Outro.popup_centered()
	
	
func _on_Home_pressed():
	RoomsManager.levels+=1
	RoomsManager.points+=int($Punti.text)
	#RoomsManager.seconds+=seconds;
	RoomsManager.saveEnviroment()
	SceneManager.goto_scene("res://Home.tscn")


func _on_Verifica_pressed():
	
	for i in range (0, nRows):
		for k in range (0, nCols):
			#print(shoesOrder[sudokuSolve[i][k]-1])
			#print(sudokuCurr[i][k])
			if not shoesOrder[int(sudokuSolve[i][k])-1] in sudokuCurr[i][k]:
				#print(winOrNot)
				winOrNot = false
				$TimerWrong.start()
				RoomsManager.lifes -= 1
				$Vite.text=str(RoomsManager.lifes)
				return
	winOrNot = true
	$Monete.text = str(1000)
	for m in range(0, 10):
		Utility.loadCoin("Livello2",$Vittoria.rect_position - Vector2(515+50*m,568+50*m))
	return
	
	
func setVisible():
	
	#$Punti.visible = true
	#$Forziere.visible=true
	$Top_Menu_Bar.visible=true
	$Tempo.visible=true
	$Vita1.visible=true
	$Vite.visible=true
	$Moneta.visible=true
	$Monete.visible=true
	$Exit.visible=true
	$Pause.visible=true
	$Verifica.visible=true
	$Griglia.visible=true
	
	for i in range(0, len(shoesOrder)):
		get_node_or_null(shoesOrder[i]+"5").visible = true
	
	
func _on_GameInfo_confirmed():
	Utility.inGame = true
	setVisible()
	$Vite.text=str(RoomsManager.lifes)

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
	

func _on_Alert_confirmed():
	SceneManager.goto_scene("res://Home.tscn")


func _on_Exit_pressed():
	Utility.inGame=false
	$Alert.popup_centered()
	
	
func cancelled():
	Utility.inGame=true


func _on_Inizia_pressed():
	Utility.inGame = true
	setVisible()
	$Vite.text=str(RoomsManager.lifes)
	$Intro.queue_free()


func _on_Esci_pressed():
	SceneManager.goto_scene("res://Home.tscn")


func _on_Continua_pressed():
	
	RoomsManager.updateState(2, int($Punti.text), Utility.seconds, RoomsManager.lifes)
	#RoomsManager.levels+=1
	#RoomsManager.points+=int($Punti.text)
	#RoomsManager.seconds+=int($Tempo.text)
	#RoomsManager.saveEnviroment()
	SceneManager.goto_scene("res://Home.tscn")
