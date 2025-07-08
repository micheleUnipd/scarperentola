extends KinematicBody2D

var points=0;
var minx = -465;
var maxx = 465;
var miny = -515
var maxy = 3

signal shoesGreen_taken;
signal shoesRed_taken;
#signal shoesBlack_taken;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#var acc = 300;
	var velocity = Vector2();
	
	if Input.is_key_pressed(KEY_W) and (self.position.y > miny) and Utility.inGame:
		#print(self.position.x)
		velocity.y = -1
		#self.position.y -= velocity;
	if Input.is_key_pressed(KEY_S) and (self.position.y < maxy) and Utility.inGame:
		velocity.y = 1 
		#self.position.y += velocity;
	if Input.is_key_pressed(KEY_A) and (self.position.x > minx) and Utility.inGame:
		velocity.x = -1
		 #self.position.x -= velocity;
	if Input.is_key_pressed(KEY_D) and (self.position.x < maxx) and Utility.inGame:
		velocity.x = 1
		 #self.position.x += velocity;
	
	var _collision = self.move_and_collide(velocity.normalized()*delta*Utility.basketAcc);
	#if collision: print(collision.collider.name)
	
	var collision_dect=false;
	var collider;
	for i in range(1,5):
		if get_node("RayCast2D"+str(i)).is_colliding():
			collision_dect=true;
			collider=get_node("RayCast2D"+str(i)).get_collider()
			break
				
	#if $RayCast2D1.is_colliding():
	if collision_dect:
		#var collider = $RayCast2D1.get_collider();
		#print("collisione "+collider.name);
		if collider and ("ScarpaVerde" in collider.name):
			points += 30;
			emit_signal("shoesGreen_taken", points);
			collider.free();
			Utility.loadCoin("Livello1", position);
		elif collider and ("ScarpaRossa" in collider.name):
			emit_signal("shoesRed_taken");
			
		elif collider and ("ScarpaNera" in collider.name):
			emit_signal("shoesRed_taken")
		elif collider and ("ScarpaBlu" in collider.name):
			emit_signal("shoesRed_taken")
			#var lifeNode = find_node("Vita"+str(life));
			#var lifeNode = get_node("/root/Main/Vita"+str(life));
			#lifeNode.queue_free();
			


	
	
	#SPAWN SHOES
	#if Input.is_key_pressed(KEY_C):
	#	var shoesScene = load("res://Scarpe.tscn");
	#	var shoesNode = shoesScene.instance();
	#	get_node("/root/Main").add_child(shoesNode);
