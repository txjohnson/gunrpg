extends TileMap


export var width  :int = 100
export var height :int = 80
export var startx :int = 50
export var starty :int = 40


enum { GOEAST, GOWEST, GONORTH, GOSOUTH, GOLAST, FORK, BUILD, DIE }


var rng :RandomNumberGenerator

func one_in (n :int):
	return rng.randi_range(1, n) == 1

class Turtle:
	var state           :int
	var weights         = [10, 10, 10, 10, 500, 10, 5, 1]
	var x               :int
	var y               :int
	var rng             :RandomNumberGenerator
	var wsum            :int = 0
	var dead            :bool = false
	var id              :int
	
	func _init (ix :int, iy :int, r :RandomNumberGenerator, i :int):
		x = ix
		y = iy
		rng = r
		id = i
		for i in weights:
			wsum += i
		
		state = choose_action()
		while state == GOLAST || state == DIE:
			state = choose_action ()
		
	func next_state() -> int:
		return choose_action ()
		
	func choose_action () -> int:
		var n = rng.randi_range (0, wsum)
		for i in range(0, 8):
			if weights[i] > n:
				return i
			n -= weights[i]
		return -1


var turtles = []
var nextid = 1

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	generate()
	pass # Replace with function body.


func generate ():
	turtles .push_back(Turtle .new (startx, starty, rng, 0))

	for iterations in range(0, 100):
		if turtles .empty():
			return
			
		for t in turtles:
			perform_action (t, t.next_state())
			
		for i in range (turtles.size() - 1, -1, -1):
			if turtles[i].dead == true:
				turtles .remove (i)


func perform_action (t :Turtle, ns :int) -> void:
#	print("perform action: (", t.id, ": ", t.x, ", ", t.y, ") -> ", ns)
	set_cell (t.x, t.y, 0)
	match ns:
		GOEAST:
			if t.x < width:
				t.x = t.x + 1
		GOWEST:
			if t.x > 0:
				t.x = t.x - 1
		GONORTH:
			if t.y > 0:
				t.y = t.y - 1
		GOSOUTH:
			if t.y < height:
				t.y = t.y + 1
		GOLAST:
			if t.state < GOLAST:
				perform_action (t, t.state)
		FORK:
			turtles .push_back (Turtle.new (t.x, t.y, rng, nextid))
			++nextid
		BUILD:
			pass
		DIE:
			t.dead = true

	if ns != GOLAST:
		t.state = ns

func _input(event):
	if (event .is_action_pressed("ui_select")):
		clear ()
		turtles .clear()
		generate()
