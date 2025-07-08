extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StampaLista_pressed():
	print(Utility.loadFile())
	
	
func _on_AggiungiUtente_pressed():
	Utility.saveFile(Utility.loadFile()+$CodiceUtente.text+",0"+",5"+",1"+",0"+"\n")


func _on_Reset_pressed():
	Utility.saveFile("")
