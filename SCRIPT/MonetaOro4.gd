extends Node2D

var forzierePose;
var coeff;
var cestoPose;
var moveX;
var direction;
var eps = 1;


# Called when the node enters the scene tree for the first time.
#func _ready():
	
	#cestoPose = position;
	#forzierePose = position + Vector2(200,-250)
	#direction = Utility.coinsPose - cestoPose;
	#coeff = -1*(forzierePose.y - cestoPose.y)/(forzierePose.x-cestoPose.x);
	#moveX = cestoPose.x;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
	#if position.distance_squared_to(Utility.coinsPose)<eps:
		#queue_free();
	#moveX += 300*delta;
	#self.position = Vector2(moveX, cestoPose.y+coeff*(moveX-cestoPose.x));
	#else:
		#self.position += direction/300
		#self.rotate(0.012)
