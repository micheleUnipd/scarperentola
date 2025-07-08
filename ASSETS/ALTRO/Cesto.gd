extends Sprite

var minx = 50;
var maxx = 972;
var miny = 30;
var maxy = 570;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = delta*300;
	
	if Input.is_key_pressed(KEY_W) && (self.position.y > miny):
		 self.position.y -= velocity;
	if Input.is_key_pressed(KEY_S) && (self.position.y < maxy):
		 self.position.y += velocity;
	if Input.is_key_pressed(KEY_A) && (self.position.x > minx):
		 self.position.x -= velocity;
	if Input.is_key_pressed(KEY_D) && (self.position.x < maxx):
		 self.position.x += velocity;
	
	#SPAWN SHOES
	#if Input.is_key_pressed(KEY_C):
	#	var shoesScene = load("res://Scarpe.tscn");
	#	var shoesNode = shoesScene.instance();
	#	get_node("/root/Main").add_child(shoesNode);
