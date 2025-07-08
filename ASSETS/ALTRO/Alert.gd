extends AcceptDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	#popup()
	#to avoid busy child error in debugger
	call_deferred("popup_centered")
	#popup_centered()
