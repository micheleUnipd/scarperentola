extends AcceptDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#popup()
	
	#to avoid busy child error in debugger
	#call_deferred("popup_centered")
	#popup_centered()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#this is not a bug, it happens only in the very specific situation when you are:

# 1: calling popup() from the popup itself
# 2: calling it in _ready()
#this will fail to raise the popup, because the parent is busy setting up children nodes. This will make it work:
#call_deferred("popup")

