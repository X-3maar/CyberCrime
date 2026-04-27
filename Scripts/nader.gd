extends Area2D

var password
var dio = Dialog.new()
var	dialog:=dio.start(self)
var mr=dialog.Character("Nader's Laptop", Color.SKY_BLUE,"res://Assets/Abdeltawab.jpeg")

func _ready() -> void:
	dialog.typewriter_speed=25
	dialog.typewriter=true

func send_to_parent(message: String):
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.parent.postMessage('" + message + "', '*');")

func talk():
	dialog.say("This is Nader's laptop",mr)
	dialog.say("Solve the following CTF and submit the secret code to crack his laptop: x.com",mr) 
	password = await dialog.input("Enter the secret code: ",mr)
	if password == "cybercrime{i_don't_give_a_shit}":
		send_to_parent("cybercrime{i_don't_give_a_shit}")
		queue_free()
	else:
		dialog.say("Your code is incorrect...",mr)

func _on_body_entered(body: Node2D) -> void:
	talk()
