extends Node

#active debugging
var debug = false

#scaling factor for the device
#var scaling = Vector2(1.87, 1.6)
#var scaling = Vector2(1.3, 1.3)
var scaling = Vector2(1, 1)
var scaleFactor = 0.10

#define radius of collision
var eps = 5;

#define the area of the game
var minX = 0
var maxX = 980
var maxY = 600
var minY = 200 #check !!!

#define the velocity of the players, coins and enemy
#var acc = 300 * scaling.length()#/Vector2(1, 1).length())
var basketAccStart = 250
var basketAcc = 0#150 * scaling.length()*scaling.length()*scaling.length()
var scarpAcc = 300
var enemyAcc = 400
var coinAcc = 300
var platformAcc = 250
var jumpAcc = -10000

#define the velocity of the fata
var fataAcc = 200
#define the fata animation rotation velocity (number of rotations in a second)
var fataRot = 8
#define the angle of the fata rotation
var fataAngle = 0.4

#secret handling
var secretActive = false
var fataArrived = false
var secretCode = ""

#welcome message handling
var gameStart=false

#pause or exit handling
var inGame = false

#enemy handling
var lastDirection=0 
var velocity = [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)]
var angles = [0, 1.57, 3.14, 4.71]
var startEnemyTube = [Vector2(0, 0), Vector2(0, 0)]

#bullet handling
var bulletVelocity = [Vector2(1,0),Vector2(0,-1),Vector2(-1,0),Vector2(0,1)]
var bulletAngles = [0, 4.71, 3.14, 1.57]
#TEST OK 
var bulletPose = Vector2(-50, -50)
#define the starting position of the bullet from the player
var bulletDist = 50
#define the velocity of the bullet
var bulletAcc = 1500

#gravity handling
var gravity = true
var gravityVector = Vector2(0,  500)

#time between two consecutive frames
var deltaTime = 0
#time elapsed of the level
var seconds = 0

#change between start and pause button
var pauseStart = 0

#player position in the labyrinth game or platforms game
var playerPose = Vector2(0,0)
#player in a moving platform or not
var inPlat=false
#velocity of the moving platform
var onPlatVelocity
#collision safe margin for controlling the moving platform
var onPlatMargin = 14.0
#normal collision margin
var normalMargin = 0.08
#coin collect
var coinCollect = false
#player on stair or not
var onStair = false
#the player took the key
var keyTaken = false
#the player use the key
var keyUsed = false
#the player open the door
var doorOpen = false
#key animation time
var keyTime = 2
#the player action a lever at scene[i]
var leverOn = [false, false, false, false, false, false, false]
#the player is at that scene
var currentScene = 1

#temporary points accumlated in the current level
var points = 0
#temporary lifes in the current level
var lifes = 0
#points collected for every coin
var coinPoints = 30

#coins pose
var coinsPose = Vector2(0, 0);

#animation handling when enemy is killed
var enemyKilled = false

#flashing animation handling
var dutyCicle = 0
var alphaFlash = 0
var alphaFactor = 150.0

#animation active or not
var animationActive = true
#door open velocity
var doorAcc = 10
#door animation is finished
var doorAnim = false
var lastDoor = false
#bridge animation is finished
var bridgeAnim = [false, false, false, false, false, false, false, false] 
#activate the broken wall animation
var startBrokenWall = false
var lastPoseBrokenWall
var brokenGround = false

var extendsStair1 = false
var extendsStair2 = false
var lastKeyTaken = false
var lastKeyRemove = false
var lastKeyUsed = false

#return time in hours, minutes and seconds starting from seconds
func timeCalculate(s):
	var temp = s;
	var hours = int(temp/3600);
	temp-=hours*3600
	var minutes = int(temp/60)
	temp-=minutes*60
	return [hours, minutes, temp]

#load coin in the current scene
func loadCoin(level, pose):
	var coinScene = load("res://MonetaOro.tscn");
	var coinNode = coinScene.instance();
	coinNode.position = pose + Vector2(515,568);
	#print(coinNode.position);
	get_node("/root/"+level).add_child(coinNode);

#return true if the object is still in the gaming area
func inGameArea(x, y):
	if x < minX or x > maxX or y > maxY:
		return false
	return true

#return true if the two object is colliding
func check_collision(pose1, pose2):
	if pose2.distance_to(pose1) < 10*eps:
		return true;
	return false;

#return true if the two object is colliding
func check_collision_eps(pose1, pose2, refine):
	if pose2.distance_to(pose1) < 10*eps*refine:
		return true;
	return false;

#save data to the file
func saveFile(content):
	var file = File.new();
	#file.open("user://save_game.dat", File.WRITE);
	file.open("user://save_game.dat", File.WRITE);
	file.store_string(content);
	file.close();

#load current progress from the file
func loadFile():
	var file = File.new();
	#file.open("user://save_game.dat", File.READ);
	file.open("user://save_game.dat", File.READ);
	var content = file.get_as_text();
	file.close();
	return content;


#return an array composed by the ciphers of a number
func cifre(n):	
	var cifre = []
	var nextC
	#var divisore = 10
	var tempN = n
	while (tempN>0):
		nextC = tempN%10
		cifre.append(nextC)
		tempN-=nextC
		tempN/=10;
	return cifre
	
#return the reverse of a string
func reverseString(s):
	var temp = ""
	print(s)
	for i in range(len(s)-1, 0, -1):
		temp += s[i]
		#print(temp)
	return temp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func updateTime(delta):
	deltaTime += delta
	if deltaTime>=1 : 
		seconds+=1
		deltaTime=0


#Create all permutations of a string with non-repeating characters
func permutations(string):
	var permutation_list = []
	if len(string) == 1:
		return string
	else:
		for c in string:
			for a in permutations(string.replace(c, "")):
				permutation_list.append(c + a) 
	return permutation_list

#remove duplicates from a string
func removeDuplicates(string):
	var resultantList = []
	for element in string:
		if not (element in resultantList):
			resultantList.append(element)
	return resultantList
	

func createSudokuSchema(n):
	
	var sudokuSchema = []
	var s = ""
	for i in range(1, n+1):
		s += str(i)
		
	var permutation_list = permutations(s)
	#print(len(permutation_list))
	
	randomize()
	var i = randi()%len(permutation_list)
	#print(i)
	sudokuSchema.append(permutation_list[i])
	var nrighe = 1
	
	while(nrighe<n):
		i = randi()%len(permutation_list)
		#print(i)
		sudokuSchema.append(permutation_list[i])
		if checkSol(sudokuSchema):
			nrighe += 1
		else:
			sudokuSchema.remove(len(sudokuSchema)-1)
	
	return sudokuSchema
	
	
func checkSol(sudokuSchema):
	
	#print(sudokuSchema)
	#print(len(sudokuSchema[0]))
	#print(len(sudokuSchema))
	
	#return true
	
	var column = ""
	for j in range(0, len(sudokuSchema[0])):
		column = ""
		for i in range(0, len(sudokuSchema)):
			column += sudokuSchema[i].substr(j,1)
		#print(column)
		#return true
		if len(removeDuplicates(column))<len(column):
			#print(column+"/n")
			#print("Duplicates found")
			return false
	
	return true

func changeFormat(sudokuSchema):
	
	var result = []
	var temp = []
	for i in range(0, len(sudokuSchema)):
		temp = []
		for j in range(0, len(sudokuSchema[i])):
			temp.append(sudokuSchema[i].substr(j,1))
		result.append(temp)
		
	return result


func randPermutation(s):
	randomize()
	var permutation_list = permutations(s)
	return permutation_list[randi()%len(permutation_list)]


func rescaleX(rootNode, factor):
	Utility.scaling += Vector2(factor, 0)
	rootNode.scale = scaling
	#pass


func rescaleY(rootNode, factor):
	Utility.scaling += Vector2(0, factor)
	rootNode.scale = scaling
	

func flash(timeOn):
	dutyCicle += 1
	if dutyCicle%10 < timeOn:
		return true
	else:
		return false


func alphaFlashing():
	alphaFlash += 1
	return (alphaFlash%int(alphaFactor))/alphaFactor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	basketAcc = basketAccStart * scaling.length()#*scaling.length()*scaling.length()
#	pass
