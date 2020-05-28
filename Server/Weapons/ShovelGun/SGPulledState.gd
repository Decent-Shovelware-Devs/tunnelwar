extends "res://Scripts_General/Base_Classes/FSM/State.gd"

var ShovelGun 
var duration = 0

func enter():
	ShovelGun = get_parent().get_parent()
	assert("ShovelGun" in ShovelGun.name) 
	
	ShovelGun.velocity = Vector2(1, 0).rotated(ShovelGun.rotation) * ShovelGun.pull_back_dist
	ShovelGun.newPos = ShovelGun.position + (ShovelGun.velocity * 1/60) #1/60 to simulate delta
	ShovelGun.rpc("_pre_stabbing", ShovelGun.position, ShovelGun.newPos)
	
	if ShovelGun.isLoaded():
		ShovelGun.get_node("Shovel").get_node("StateMachine").change_to("ShChargedState")
		 
	duration = 0
	
# Optional handler functions for game loop events
func process(delta):
	duration += delta
	
		
	if not ShovelGun.stab_btn_p:  #todo check timer for stab potential
		if duration > ShovelGun.stab_charge_time:
			if ShovelGun.shoot_btn_p and ShovelGun.isLoaded():
				ShovelGun.rpc("shoot")
				
			fsm.change_to("SGStabState")
			
		else:
			ShovelGun.rpc("_after_stabbing", ShovelGun.position, ShovelGun.init_position)
			fsm.change_to("SGDefaultState") 

