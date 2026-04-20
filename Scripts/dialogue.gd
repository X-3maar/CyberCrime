extends Area2D

var dio = Dialog.new()
var	dialog:=dio.start(self)
var mr=dialog.Character("Mr.AbdelTawab", Color.RED,"res://addons/dialog_system/placeholder.png")
func _ready() -> void:
	dialog.typewriter_speed=15
	dialog.typewriter=true
func talk():
	dialog.say("Hello there!",mr) 
	dialog.say("Xxxx xxx xxx xxx",mr) 
func _on_body_entered(body: Node2D) -> void:
	talk()
	
