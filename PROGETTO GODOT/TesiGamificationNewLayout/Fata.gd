extends Sprite

#var arrived = false
var rot = 1;
var timer = 0;
var finalPos;
var velocity = Vector2(1, 0)
var pulseTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(-130, 80)
	#rotate(0.2)
	finalPos = Vector2(380, 75)
	#print(self.modulate)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	velocity = velocity.normalized()*delta*Utility.fataAcc
	timer += delta
	
	pulseTime+=1
	
	if Utility.secretActive and not Utility.fataArrived: 
		#position += Vector2(1, 0);
		position += velocity
		if timer>(1.0/Utility.fataRot):
			rot *= -1
			rotate(rot*Utility.fataAngle) 
			timer = 0;
			
		#self.modulate = Color(0.8 + (pulseTime%20)/20.0, 1, 0)
		#if pulseTime%10<4:
		#	visible=false
		#else:
		#	visible = true
			
	if Utility.check_collision(position, finalPos):
		Utility.fataArrived = true;
		visible = true
		rotation = 0 
	
