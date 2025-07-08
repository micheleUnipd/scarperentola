extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Animation.start()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Animation.time_left>0:
		for i in range(1, 4):
			get_node_or_null("Sprite"+str(i)).position-=i*30*delta*Vector2(1, -2)
	else:
		queue_free()
