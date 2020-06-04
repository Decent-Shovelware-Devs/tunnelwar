extends Node

class_name StateMachine

signal on_state_change

const DEBUG = false

var state: Object

var history = []

func _ready():
	# Set the initial state to the first child node
	state = get_child(0)
	_enter_state()
	
func change_to(new_state):
	history.append(state.name)
	state = get_node(new_state)
	_enter_state()
	
	emit_signal("on_state_change")

func back():
	if history.size() > 0:
		state = get_node(history.pop_back())
		_enter_state()

func _enter_state():
	if DEBUG:
		print("Entering state: ", state.name)
	# Give the new state a reference to this state machine script
	state.fsm = self
	state.fsm_root = get_parent()
	state.enter()

# Route Game Loop function calls to
# current state handler method if it exists
func _process(delta):
	if state.has_method("process"):
		state.process(delta)

func _physics_process(delta):
	if state.has_method("physics_process"):
		state.physics_process(delta)
		
func _input(event):
	if state.has_method("input"):
		state.input(event)

func _unhandled_input(event):
	if state.has_method("unhandled_input"):
		state.unhandled_input(event)

func _unhandled_key_input(event):
	if state.has_method("unhandled_key_input"):
		state.unhandled_key_input(event)

func _notification(what):
	var state_ref = null 
	if state:
		state_ref = weakref(state)
		state_ref = state_ref.get_ref()
	if state_ref && state_ref.has_method("notification"):
		state_ref.notification(what)
