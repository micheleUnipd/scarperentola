extends Node2D

var inGame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Forziere.visible=false
	$Punti.visible = false
	$Tempo.visible=false
	$GameInfo.popup_centered()

func setVisible():
	$Forziere.visible=true
	$Punti.visible = true
	$Tempo.visible=true
	$Exit.visible=true
	$Pause.visible=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inGame:
		Utility.updateTime(delta)
		$Tempo.text=str(Utility.timeCalculate(Utility.seconds)[0])+":"+str(Utility.timeCalculate(Utility.seconds)[1])+":"+str(Utility.timeCalculate(Utility.seconds)[2])


func _on_Alert_confirmed():
	SceneManager.goto_scene("res://Home.tscn")


func _on_Pause_pressed():
	if (Utility.pauseStart % 2 == 0):
		$Pause.text="GIOCA"
		inGame=false
		set_process(false)
	else:
		$Pause.text="PAUSA"
		inGame=true
		set_process(true)
	Utility.pauseStart += 1


func _on_Exit_pressed():
	$Alert.popup_centered()


func _on_GameInfo_confirmed():
	inGame=true
	setVisible()
	
