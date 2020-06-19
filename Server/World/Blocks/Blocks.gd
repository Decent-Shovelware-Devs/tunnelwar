extends Node

var block_dict = {} # key = Vector2

const Blocks = {
	#scenes
	"Dirt": preload("res://World/Blocks/Dirt/Dirt.tscn"), 
	"GoldOre" : preload("res://World/Blocks/GoldOreBlock/GoldOreBlock.tscn"),
}

const chunk_length = 20

#chance a block is gold
export var gold_chance = 5 

#generates a chunk at position
#RETURNS if a block already exists at the location
func generate_chunk(origin_coord : Vector2):
	if origin_coord in block_dict:
		return 
		
	var top_left = origin_coord - Vector2(chunk_length/2, chunk_length/2)
	
	for row in range(chunk_length):
		for col in range(chunk_length):
			var instance = null
			if randi() % 100 <= gold_chance:
				instance = Blocks["GoldOre"].instance()
			else:
				instance = Blocks["Dirt"].instance() 
				
			instance.position = gamestate.get_pos(top_left + Vector2(row, col))
			add_child(instance)
			block_dict[instance.coord] = instance
