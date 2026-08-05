extends CanvasLayer

class_name  Dialog_system
#NPC Dialog imports
@onready var npc: Label = %npc_name
@onready var convo: RichTextLabel = %convo
@onready var photo: TextureRect = %photo
@onready var next_convo: Button = %next_convo
@onready var bg_obj: TextureRect = %bg
@onready var sound_tool: AudioStreamPlayer = %sound

@onready var menu_object=preload("res://addons/dialog_system/menu.tscn")
@onready var input_object=preload("res://addons/dialog_system/input.tscn")
signal input_received(value)
signal talking(value)
signal dialogue_step_completed
var paused:=false
var current_tween: Tween
var start:=false
var processing_queue:=false
var dialog_output:=[]:
	set(value):
		dialog_output=value
		start_convo()
var Characters:={
	"default":{
		"color":Color.WHITE,
		"image":"res://addons/dialog_system/placeholder.png"}
}
var typewriter_speed:=30
var typewriter:=true
#backward compatibility
var text:="":
	set(value):
		text=value
		old_text(value)
#usable varibles 
var npc_name:="":
	set(value):
		npc_name=value
		changed_NPC_name(value)

var image:="":
	set(value):
		image=value
		change_image(value)
		

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	start=true
	npc.text=npc_name
	hide()

func start_convo():
	if not paused and not processing_queue:
		start=false
		proceed_loop()

func add_dialog(type,line):
	if start:
		dialog_output=[{type:line}]
	else:
		dialog_output.append({type:line})

func changed_NPC_name(value):
	if Characters.size()<2:
		Character(value)
	add_dialog("npc_name",{"name":value})
	
		
		

func change_image(value):
	add_dialog("image",{"image":value})
#Usable functions

func Character(NPC_NAME:String,color:Color=Color.WHITE,image_avatar:String ="res://addons/dialog_system/placeholder.png")->String:
	Characters[NPC_NAME]={
		"color":color,
		"image":image_avatar
	}
	return NPC_NAME
func bg(url:String):
	add_dialog("bg",{"bg":url})

func voice(url:String,volume_dB:float=0,pitch_scale:float=1):
	add_dialog("voice",{
		"url":url,
		"volume_dB":volume_dB,
		"pitch_scale":pitch_scale,
	})
#old text style (backward compatiblity):
func old_text(value):
	add_dialog("text",{
	"text": value,
	"typewriter": typewriter,
	"speed": typewriter_speed,
	})
func say(text:String,NPC_name:String=npc_name,typewriter:bool=typewriter,speed:float=typewriter_speed):
	var current_npc=""
	if NPC_name=="":
		current_npc="default"
	else :
		current_npc=NPC_name
	changed_NPC_name(NPC_name)
	avatar(Characters[current_npc]["image"])
	add_dialog("text",{
	"text": text,
	"typewriter": typewriter,
	"speed": speed,
	})

func avatar(value):
	if image.length()<1:
		add_dialog("image",{"image":value})
		
var user_input:=""
#Input 
func input(question:String,userInput:String=""):
	add_dialog("input",{
	"question": question,
	})
	await input_received
	next_convo.disabled=false
	
	return user_input
	
func menu(question:String, choices:Dictionary):
	add_dialog("menu",{
	"question": question,
	"choices": choices,
	})	

func action(function_name):
	add_dialog("action", function_name)
		
func process_npc_name(key):
	npc.text=key["npc_name"]["name"]
	set_Char(key["npc_name"]["name"])
	
	
func process_image(key):
	photo.texture=load(key["image"]["image"])

func process_bg(key):
	bg_obj.texture=load(key["bg"]["bg"])

func process_voice(key):
	sound_tool.stream=load(key["voice"]["url"])
	sound_tool.volume_db=key["voice"]["volume_dB"]
	sound_tool.pitch_scale=key["voice"]["pitch_scale"]
	sound_tool.play()
#text	
func process_text(key):
	convo.text=key["text"]["text"]
	convo.visible_characters=-1
	
	if key["text"]["typewriter"]:
		var speed=convo.get_total_character_count()/key["text"]["speed"]
		convo.visible_characters=0
		current_tween=create_tween()
		current_tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
		current_tween.tween_property(convo,"visible_characters",convo.get_total_character_count(),speed)
			
func process_input(key):
	var input_inst:Dailog_Input=input_object.instantiate()
	input_inst.user_input_changed.connect(_on_user_input_change)
	add_child(input_inst)
	input_inst.show()
	input_inst.input_Q=key["input"]["question"]

func _on_user_input_change(value):
	user_input=value
	input_received.emit(value)

func process_menu(key):
	var choices={"question":key["menu"]["question"],"choices":key["menu"]["choices"]}
	var menu_inst=menu_object.instantiate()
	menu_inst.choices=choices
	add_child(menu_inst)
	menu_inst.show()
	
func process_action(key):
	get_parent().call(key["action"])
	
func proceed_loop():
	if processing_queue:
		return
	processing_queue = true
	show()
	
	while dialog_output.size() > 0 and not paused:
		talking.emit(self)
		var key = dialog_output[0]
		var type = key.keys()[0]
		
		match type:
			"text":
				get_tree().paused = true
				process_text(key)
				await dialogue_step_completed
				get_tree().paused = false
			"input":
				get_tree().paused = true
				next_convo.disabled = true
				process_input(key)
				await input_received
				get_tree().paused = false
			"menu":
				get_tree().paused = true
				next_convo.disabled = true
				process_menu(key)
				processing_queue = false
				return
			"image":
				process_image(key)
			"bg":
				process_bg(key)
			"voice":
				process_voice(key)
			"npc_name":
				process_npc_name(key)
			"action":
				process_action(key)
				
		dialog_output.erase(key)
		
		if type != "text" and type != "input" and type != "menu":
			await get_tree().process_frame

	if dialog_output.size() == 0:
		hide()
		start = true
		
	processing_queue = false
		
func _on_next_convo_pressed() -> void:
	if convo.visible_characters < convo.get_total_character_count():
		if current_tween and current_tween.is_running():
			current_tween.kill()
		convo.visible_characters=convo.get_total_character_count()
	else:
		dialogue_step_completed.emit()

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept"):
		_on_next_convo_pressed()
		get_viewport().set_input_as_handled()
	
func set_Char(NPC_NAME):
	var current_npc=""
	if NPC_NAME=="":
		current_npc="default"
	else :
		current_npc=NPC_NAME	
	convo.add_theme_color_override("default_color",Characters[current_npc]["color"])
	npc.add_theme_color_override("font_color",Characters[current_npc]["color"])	
