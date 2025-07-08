extends Sprite

var rightPose = Vector2(367, 341);
#var initialPose = Vector2(576, 495);
var initialPose;

func _input(event):
	
	#if event is InputEventMouseButton and event.position.dista:
		
	
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(1) and Utility.inGame(event.position.x, event.position.y): 
			position = event.position
		
		elif not Input.is_mouse_button_pressed(1):
			if position.distance_squared_to(rightPose)<100*Utility.eps:
				position = rightPose
				Utility.rightFragment+=1;
			else: position = initialPose

# Called when the node enters the scene tree for the first time.
func _ready():
	initialPose = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
