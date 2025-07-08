extends RigidBody2D

var alphaFlash = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Bolla.scale *= Utility.scaling

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if Utility.inGame:
		alphaFlash += 1
		$Bolla.modulate.a = (alphaFlash%int(Utility.alphaFactor))/Utility.alphaFactor
	
	if not Utility.inGameArea(position.x, position.y):
		queue_free()
