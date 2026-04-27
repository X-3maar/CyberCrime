extends Area2D

var dio = Dialog.new()
var	dialog:=dio.start(self)
var mr=dialog.Character("Dr.AbdelTawab", Color.SKY_BLUE,"res://Assets/Abdeltawab.png")
func _ready() -> void:
	dialog.typewriter_speed=25
	dialog.typewriter=true
func talk():
	dialog.say("Hello, everyone. I’m Dr. Abdeltawab, your CS teacher. I've got some bad news..",mr) 
	dialog.say("Just after I logged on this morning, I discovered that every single server in the school has been hacked. It’s a full-scale hack, which is why the internet has been down for a while.",mr) 
	dialog.say("I’ve gathered several accounts of what happened leading up to the crash. Using the clues and keys from laptops left in the crime scene, can you investigate and identify the impostor behind this crime?",mr)
func _on_body_entered(body: Node2D) -> void:
	talk()
	position.y = -3000
