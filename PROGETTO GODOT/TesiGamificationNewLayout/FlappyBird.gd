extends KinematicBody2D

var points=0;
var minx = -465;
var maxx = 465;
var miny = -515
var maxy = 3


var timer = 3
#signal shoesGreen_taken;
#signal shoesRed_taken;
#signal shoesBlack_taken;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var acc = 300;
	var velocity = Vector2();
	
	#$TimerMove.start()
	if Input.is_key_pressed(KEY_SPACE) and (self.position.y > miny):
		#print(self.position.x)
		#if $TimerMove.time_left==0: 
		if timer<0: 
			velocity.y = -125
			#print("to do")
			#$TimerMove.start()
			timer = 3;
			
		#self.position.y -= velocity;
	if Input.is_key_pressed(KEY_S) and (self.position.y < maxy):
		velocity.y = 0.5 
		#self.position.y += velocity;
	if Input.is_key_pressed(KEY_A) and (self.position.x > minx):
		velocity.x = -0.5
		 #self.position.x -= velocity;
	if Input.is_key_pressed(KEY_D) and (self.position.x < maxx):
		velocity.x = 0.5
		 #self.position.x += velocity;
	
	timer-=delta
	
	#print($TimerMove.time_left)
	#print(timer)
	velocity.y += 0.001
	print(velocity)
	var _collision = self.move_and_collide(velocity.normalized()*delta*acc);
	#if collision: print(collision.collider.name)
	
