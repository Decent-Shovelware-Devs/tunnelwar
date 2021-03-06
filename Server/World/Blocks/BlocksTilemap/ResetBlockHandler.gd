extends Node

#gameplay 
var reset_blocks = 2 #num of reset blocks to break until reset
var rb_hp = 2
var rb_respawn_time = 10
var hit_cd = 2 #seconds until it can be hit again 

#implementation
var reset_block : Vector2 #reference to current reset block
var _current_rb  #num of reset blocks to break until reset
var _current_rb_hp 
var _current_hit_cd  

var blocks_tm : Blocks

func _ready():
	blocks_tm = get_parent() 
	_current_rb = reset_blocks 
	_current_hit_cd = hit_cd
	
func _process(delta):
	if _current_hit_cd > 0:
		_current_hit_cd -= delta 

func handle_hit(cell : Vector2, player_index : int):
	#check if ht recently
	if not _current_hit_cd <= 0:
		return 
		
	#damaging the rb
	if _current_rb_hp > 1:
		_current_rb_hp -= 1 
		gamestate.broadcast_node.broadcast(
			"[p] strikes the reset block. %s hits remain." % _current_rb_hp, 
			3, 1, player_index)
		_current_hit_cd = hit_cd
	#breaking the rb 
	else:
		blocks_tm.set_block(cell, blocks_tm.block.EMPTY)
		_current_rb -= 1 
		gamestate.broadcast_node.broadcast("The Reset Block is destroyed. %s remain." % _current_rb, rb_respawn_time, 1)
		yield(get_tree().create_timer(rb_respawn_time), "timeout")
	
		if _current_rb > 0 and blocks_tm.get_used_cells_by_id(blocks_tm.block.DIRT).size() > 0:
			spawn_reset_block()
		else: 
			gamestate.set_game_phase(gamestate.game_phases.INTERIM)
			blocks_tm.reset()
			_current_rb = reset_blocks

func spawn_reset_block():  
	gamestate.broadcast_node.broadcast("Somewhere, a Reset Block appears. %s more until RESET." % reset_blocks, rb_respawn_time, 1)
	
	reset_block = blocks_tm.get_random_block(blocks_tm.block.DIRT)
	blocks_tm.set_block(reset_block, blocks_tm.block.RESET) 

	_current_rb_hp = rb_hp
	_current_hit_cd = hit_cd 
