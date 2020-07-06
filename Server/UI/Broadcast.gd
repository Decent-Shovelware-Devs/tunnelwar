extends Node

class_name Broadcast

var current_message = "" 
var current_message_priority = 0  

func _ready():
	gamestate.broadcast_node = self

master func initialize_rpc_sender():
	rpc_id(get_tree().get_rpc_sender_id(), "update_broadcast", current_message) 

func broadcast(message : String, duration : int, priority : int, target_player_id = -1) -> void:  
	if priority >= current_message_priority: 
		
		target_player_id = int(target_player_id)
		#replacing [p] with username
		if not target_player_id == -1:
			current_message = message.replace("[p]", gamestate.get_player(target_player_id).username)
		else:
			current_message = message 
			
		current_message_priority = priority 
		rpc("update_broadcast", current_message, target_player_id)
	
		$Timer.start(duration) 


func _on_Timer_timeout():
	rpc("end_broadcast")
	current_message_priority = 0 
	current_message = "" 
