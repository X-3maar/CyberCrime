extends Area2D

var password
var dio = Dialog.new()
var	dialog:=dio.start(self)
var mr=dialog.Character("Mostafa's Laptop", Color.SKY_BLUE,"res://Assets/Abdeltawab.jpeg")

func _ready() -> void:
	dialog.typewriter_speed=25
	dialog.typewriter=true

func send_to_parent(message: String):
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.parent.postMessage('" + message + "', '*');")

func talk():
	dialog.say("This is Mostafa's laptop",mr)
	dialog.say("Solve the following problem and submit the secret code to crack his laptop: https://codeforces.com/gym/684309",mr) 
	password = await dialog.input("Enter the secret code: ",mr)
	if password == "cybercrime{MSA}":
		send_to_parent("cybercrime{MSA}")
		queue_free()
	else:
		dialog.say("Your code is incorrect...",mr)

func _on_body_entered(body: Node2D) -> void:
	talk()
