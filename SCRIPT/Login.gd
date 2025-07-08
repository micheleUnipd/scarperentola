extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#if not os.path.isfile("user://save_game.dat"):
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Accedi_pressed():
	if $User.text == "usermanager":
		SceneManager.goto_scene("res://UserManager.tscn")
		return
	var users = Utility.loadFile()
	var start = users.find($User.text)
	if (start!=-1):
		var end = users.find("\n", start)
		var temp = users.substr(start, end-start)
	
		var data = temp.split(",")
	
		RoomsManager.user = data[0]
		RoomsManager.points = int(data[1])
		RoomsManager.lifes = int(data[2])
		RoomsManager.levels = int(data[3])
		RoomsManager.seconds = int(data[4])
		SceneManager.goto_scene("res://Home.tscn")
	else:
		SceneManager.goto_scene("res://Login.tscn")
