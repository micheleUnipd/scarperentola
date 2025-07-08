extends Node

var user = "micheleUnipd";
var points = 0;
var lifes = 5;
var levels = 1;
var seconds = 0;
var minutes = 0;
var hours = 0;

var secretFound = false
var maxLifes = 5
var maxLevels = 5


func updateState(currentL, p, s, l):
	if currentL == levels:
		RoomsManager.levels+=1
		RoomsManager.points+=p
		RoomsManager.seconds+=s
		RoomsManager.lifes=l
		RoomsManager.saveEnviroment()
	
func saveFile(content):
	var file = File.new();
	#file.open("user://save_game.dat", File.WRITE);
	file.open("res://save_game.dat", File.WRITE);
	file.store_string(content);
	file.close();

func loadFile():
	var file = File.new();
	#file.open("user://save_game.dat", File.READ);
	file.open("res://save_game.dat", File.READ);
	var content = file.get_as_text();
	file.close();
	return content;

func saveEnviroment():
	
	var users = Utility.loadFile()
	var start = users.find(user)
	if (start!=-1):
		var end = users.find("\n", start)
		users.erase(start, end-start)
		#var temp = users.substr(start, end-start)
	
		#var data = temp.split(",")
		var data = RoomsManager.user + "," + str(RoomsManager.points) + "," + str(RoomsManager.lifes) + "," + str(RoomsManager.levels) + "," + str(RoomsManager.seconds) + "\n"
	#user pwd points lifes level
	#var data = "micheleUnipd pwd 123 5 1/n";
		Utility.saveFile(data)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
