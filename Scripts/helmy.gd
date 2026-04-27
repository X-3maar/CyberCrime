extends Area2D

var password
var dio = Dialog.new()
var	dialog:=dio.start(self)
var mr=dialog.Character("Helmy's Laptop", Color.SKY_BLUE,"res://Assets/Abdeltawab.jpeg")

func _ready() -> void:
	dialog.typewriter_speed=25
	dialog.typewriter=true

func send_to_parent(message: String):
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.parent.postMessage('" + message + "', '*');")

func talk():
	dialog.say("This is Helmy's laptop",mr)
	dialog.say("Solve the following CTF and submit the secret code to crack his laptop: https://tinyurl.com/5frhnmh7",mr) 
	password = await dialog.input("Enter the secret code: ",mr)
	if password == "cybercrime{abuse@abion.com}":
		send_to_parent("cybercrime{abuse@abion.com}")
		queue_free()
	else:
		dialog.say("Your code is incorrect...",mr)

func _on_body_entered(body: Node2D) -> void:
	talk()
