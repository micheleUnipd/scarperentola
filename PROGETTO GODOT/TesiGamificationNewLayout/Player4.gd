extends KinematicBody2D

#var lastPose
var playerEnemy = false
var timerPlayerEnemy = 5
var cont = 0
var mapPoint
var xScale = 366.0/5308
var yScale = 268.0/4727

signal enemyCollision

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.play("stand_down")
	Utility.lastDirection = 0
	mapPoint = self.get_parent().get_node("CanvasLayer/Maps/Indicatore")
	#lastPose=0


func _process(delta):
	
	var velocity = Vector2();
	
	if Utility.inGame:
		if Input.is_key_pressed(KEY_W):# and (self.position.y > miny):
			#print(self.position.x)
			if Utility.animationActive: $Player.play("walk_up")
			velocity.y = -1
			Utility.lastDirection = 1
			#self.position.y -= velocity;
		if Input.is_key_pressed(KEY_S):#and (self.position.y < maxy):
			if Utility.animationActive: $Player.play("walk_down")
			velocity.y = 1
			Utility.lastDirection = 3 
			#self.position.y += velocity;
		if Input.is_key_pressed(KEY_A):# and (self.position.x > minx):
			if Utility.animationActive: 
				$Player.play("walk_left")
				$Player.flip_h = false
			velocity.x = -1
			Utility.lastDirection = 2
			#self.position.x -= velocity;
		if Input.is_key_pressed(KEY_D) and Utility.inGame:# and (self.position.x < maxx):
			if Utility.animationActive: 
				$Player.play("walk_left")
				$Player.flip_h = true
			velocity.x = 1
			Utility.lastDirection = 0
		 #self.position.x += velocity;
	
		var collision = self.move_and_collide(velocity.normalized()*delta*Utility.scarpAcc);
		#update the player's current position
		Utility.playerPose = self.position
		
		#print(velocity.normalized().x*delta*Utility.acc)
		#print(velocity.normalized().x*delta*Utility.acc*xScale)
		var xMapUpdate = velocity.normalized().x*delta*Utility.scarpAcc*xScale
		var yMapUpdate = velocity.normalized().y*delta*Utility.scarpAcc*yScale
	
		if not collision:
			mapPoint.position.x += xMapUpdate
			mapPoint.position.y += yMapUpdate
	
		if velocity == Vector2() and Utility.animationActive:
			if $Player.animation == "walk_down":
				$Player.play("stand_down")
			elif $Player.animation == "walk_left":
				$Player.play("stand_left")
			elif $Player.animation == "walk_up":
				$Player.play("stand_up")
	
		if playerEnemy:
			timerPlayerEnemy-=delta
			#Lampeggio 4/10 spento 6/10 acceso
			cont+=1
			if cont%10 < 4:
				$Player.visible = false
			else:
				$Player.visible = true
		
		if timerPlayerEnemy<0:
			playerEnemy = false
			timerPlayerEnemy = 3
			$Player.visible = true
	
		if collision and "Enemy" in collision.collider.name and $LifesCoolDown.time_left==0:
			#print("enemy collision")
			#collision.collider.move_and_collide(Vector2(50, 0))
			#collision.collider.move_and_collide(Vector2(0, 50))
			#collision.collider.move_and_collide(Vector2(-50, 0))
			#collision.collider.move_and_collide(Vector2(0, -50))
			$LifesCoolDown.start()
			playerEnemy = true
			emit_signal("enemyCollision")
			
		#var nodes = get_parent().get_children()
		#print(nodes.name)
		#for n in nodes:
			#print(n.name)
		#	if "Enemy" in str(n.name) and Utility.check_collision(n.position, position) and $LifesCoolDown.time_left==0:
		#		$LifesCoolDown.start()
		#		playerEnemy = true
		#		emit_signal("enemyCollision")
		
		
		if collision and "Exit" in collision.collider.name:
			#RoomsManager.saveEnviroment()
			get_parent().get_node_or_null("CanvasLayer/Outro").popup_centered()
		
	
