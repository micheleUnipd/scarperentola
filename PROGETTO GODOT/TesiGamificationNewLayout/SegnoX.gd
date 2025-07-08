extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var cestoNode = get_node("/root/Livello1").find_node("Cesto2D") 
	if cestoNode: position = cestoNode.position + Vector2(515,568);
	
	if (get_node("/root/Livello1").find_node("TimerX").time_left==0):
		visible=false;
