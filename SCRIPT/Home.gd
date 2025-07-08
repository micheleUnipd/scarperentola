extends Node2D

var maxLifes = 5
var maxLevels = 5

var secretWords = ["SANDALO","POULAINE","CIOPPINA", "SAPRASCARPA", "INVISIBILE"]
var carsList=""
var lastCar='+'

func loadLifes():
	#for i in range(maxLifes, RoomsManager.lifes,-1):
		#print(i)
	#	get_node("Vita"+str(i)).visible = false
	
	$Vite.text = str(RoomsManager.lifes)
	
	#var punti = loadFile()
	#print(punti)

func loadLevels():
	
	#lock levels not completed
	for i in range(maxLevels, RoomsManager.levels,-1):
		get_node("SfondoLivello"+str(i)).visible = false
		#get_node("SfondoLivello"+str(i)).modulate = Color("50ffffff")
		#get_node("IconaLivello"+str(i)).modulate = Color("50ffffff")
		#get_node("SfondoLivello"+str(i)).texture = load("res://0 - main menu/tappa_"+str(i)+"_off.png")
	
	#$SfondoLivello1.modulate.a = 73
	#for i in range(1, RoomsManager.levels+1):
	#	get_node("Lucchetto"+str(i)).visible=false
	#	get_node("Sbloccato"+str(i)).visible=true
	
	
func loadTime():
	$Tempo.text = str(Utility.timeCalculate(RoomsManager.seconds)[0])+" : "+str(Utility.timeCalculate(RoomsManager.seconds)[1])+" : "+str(Utility.timeCalculate(RoomsManager.seconds)[2])

func loadEnviroment():
	
	#bypass login phase
	
	var dir = Directory.new();
	#dir.remove("user://save_game.dat") #PUO ESSERE FATTA CON RESET
	var doFileExists = dir.file_exists("user://save_game.dat")
	
	print(doFileExists)
	if not RoomsManager.secretFound: 
		if not doFileExists:
			Utility.saveFile("micheleUnipd"+",0"+",5"+",1"+",0"+"\n")
		else:
			var users = Utility.loadFile()
			var start = users.find("micheleUnipd")
			if (start!=-1):
				var end = users.find("\n", start)
				var temp = users.substr(start, end-start)
	
				var data = temp.split(",")
	
			#RoomsManager.user = data[0]
				RoomsManager.points = int(data[1])
				RoomsManager.lifes = int(data[2])
				RoomsManager.levels = int(data[3])
				RoomsManager.seconds = int(data[4])
	
	else: RoomsManager.secretFound = false
	$Monete.text = str(RoomsManager.points);
	loadLifes()
	loadLevels()
	loadTime()
	
	#LAYOUT CHANGED
	#load start level button
	#get_node("IniziaLivello"+str(RoomsManager.levels)).visible=true;
	
	#load restart levels button
	#for i in range(1, RoomsManager.levels):
	#	get_node("RigiocaLivello"+str(i)).visible = true
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	#adapt dimension based on the device used
	self.scale = Utility.scaling
	#Utility.rescale(self, 1.2)
	
	Utility.fataArrived = false
	loadEnviroment()
	
	#testing web-app by pass ALL 
	#RoomsManager.levels = 5
	#RoomsManager.lifes = 5
	#RoomsManager.seconds = 0
	#RoomsManager.points = 0
	#loadLifes()
	#loadLevels()
	#loadTime()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	#secretHandling();
	if Utility.fataArrived:
		$Codice.visible = true
		$UsaCodice.visible = true
		$ParolaMagica.visible = true
		$Vita1.visible = false
		$Vite.visible = false
		$Monete.visible = false
		$Moneta.visible = false
		$Top_Menu_Bar.visible = false
		$Tempo.visible = false
		Utility.secretActive = false
	

	if Input.is_key_pressed(KEY_M) and Utility.debug:
		#print(Utility.permutations("123"))
		#print(Utility.removeDuplicates("cciiao"))
		Utility.debug = false
		print(Utility.changeFormat(Utility.createSudokuSchema(5)))
	
	
	if Input.is_action_just_pressed("ui_up"):
		Utility.rescaleY(self, Utility.scaleFactor)
	
	if Input.is_action_just_pressed("ui_down"):
		Utility.rescaleY(self, -Utility.scaleFactor)
	
	if Input.is_action_just_pressed("ui_left"):
		Utility.rescaleX(self, -Utility.scaleFactor)
		
	if Input.is_action_just_pressed("ui_right"):
		Utility.rescaleX(self, Utility.scaleFactor)
		
	
	
func _input(event):
	if event is InputEventKey and not Utility.secretActive:
		if not Utility.fataArrived:
			var newCar = char(event.scancode);
			if lastCar != newCar:
				carsList += newCar
				lastCar = newCar
				print(carsList)
	
		secretHandling()
		#else:
		#	Utility.secretCode += char(event.scancode)
			
	var levelIcon
	var levelIconActive
	var levelButton
	# Mouse in viewport coordinates.
	if event is InputEventMouseMotion:
		for i in range(1, RoomsManager.maxLevels+1):
				levelIcon = get_node("SfondoLivello"+str(i))
				levelButton = get_node("IniziaLivello"+str(i))
				levelIconActive = get_node("SfondoLivello"+str(i)+"_active")
				if levelButton.rect_position.distance_to(event.position/Utility.scaling)<10*Utility.eps:
					if i<= RoomsManager.levels:
						levelButton.visible = true
						levelIcon.visible = false
						levelIconActive.visible = true
						#levelIcon.texture = load("res://0 - main menu/tappa_"+str(i)+"_attiva.png")
						return;
				else:
					levelButton.visible = false
					##print(get_node("IniziaLivello"+str(i)).rect_position)
					if i<= RoomsManager.levels:
						levelIcon.visible = true
						levelIconActive.visible = false
						#levelIcon.texture = load("res://0 - main menu/tappa_"+str(i)+"_on.png")
					
					#selected = fragment;
					#index = i-1
					#print(selected.name)
					#print(index)
					#return
		  


func secretHandling():
	
	if "SCARPERENTOLA" in carsList:
		$Fata.visible = true
		Utility.secretActive = true
		print("secret found !!!")
	
	if "RESET" in carsList:
		var dir = Directory.new();
		dir.remove("user://save_game.dat")
		Utility.saveFile("micheleUnipd"+",0"+",5"+",1"+",0"+"\n")
		SceneManager.goto_scene("res://Home.tscn")
	
	if "MANAGER" in carsList:
		SceneManager.goto_scene("res://UserManager.tscn")
	

	
#func _on_Button_pressed():
		
	#SceneManager.goto_scene("res://Livello"+str(RoomsManager.levels)+".tscn")
	

func _on_UsaCodice_pressed():
	print("usa codice")
	
	$UsaCodice.visible = false
	$Codice.visible = false
	$ParolaMagica.visible = false
	$Fata.visible = false
	
	Utility.secretActive = false
	Utility.fataArrived = false
	$Fata._ready()
	
	carsList = ""
	
	#print($Codice.text)
	if $Codice.text.to_upper() in secretWords:
		var unlockIndex = 0;
		#print("parola corretta !!!")
		for i in range(0, RoomsManager.maxLevels):
			if secretWords[i]==$Codice.text.to_upper():
				unlockIndex = i
				break
			 
		RoomsManager.levels = unlockIndex+1;
		RoomsManager.secretFound=true;
		
		RoomsManager.saveEnviroment()
		#print("Secret Found !!!");
		$Codice.text = ""
		SceneManager.goto_scene("res://Home.tscn")
	
	$Tempo.visible = true
	$Vita1.visible = true
	$Vite.visible = true
	$Monete.visible = true
	$Moneta.visible = true
	$Top_Menu_Bar.visible = true
	$Codice.text = ""

func _on_Codice_text_changed(_new_text):
	pass
	#$Codice.text = Utility.secretCode
	#print($Codice.text.to_upper())
	#print(new_text)
	#$Codice.text = Utility.reverseString()
	#$Codice.text = Utility.reverseString($Codice.text.to_upper())


func _on_RigiocaLivello1_pressed():
	SceneManager.goto_scene("res://Livello1.tscn")
	

func _on_RigiocaLivello2_pressed():
	SceneManager.goto_scene("res://Livello2.tscn")
	

func _on_RigiocaLivello3_pressed():
	SceneManager.goto_scene("res://Livello3.tscn")
	

func _on_RigiocaLivello4_pressed():
	SceneManager.goto_scene("res://Livello4.tscn")
	

func _on_RigiocaLivello5_pressed():
	SceneManager.goto_scene("res://Livello5.tscn")
	


func _on_IniziaLivello1_pressed():
	SceneManager.goto_scene("res://Livello1.tscn")


func _on_IniziaLivello2_pressed():
	SceneManager.goto_scene("res://Livello2.tscn")


func _on_IniziaLivello3_pressed():
	SceneManager.goto_scene("res://Livello3.tscn")


func _on_IniziaLivello4_pressed():
	SceneManager.goto_scene("res://Livello4.tscn")


func _on_IniziaLivello5_pressed():
	SceneManager.goto_scene("res://Livello5.tscn")
