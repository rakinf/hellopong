extends Node2D

# member variable
var screen_size
var pad_size
var direction = Vector2(-1.0, 0.0)

#constant for ball speed (in px/s)
const INITIAL_BALL_SPEED = 80
#speed of the ball (in px/s)
var ball_speed = INITIAL_BALL_SPEED
#constant for pads speed
const PAD_SPEED = 150
#constant for score
const INITIAL_SCORE = 0
#score left
var score_left = INITIAL_SCORE
#score right
var score_right

func _ready():
	randomize()
	#Called every time the node is added to the scene.
	#Initialization here
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	score_right = INITIAL_SCORE
	score_left = INITIAL_SCORE
	set_process(true)
	
func _process(delta):
	var ball_pos = get_node("ball").get_pos()
	#Rect2 used for test for collition between ball and pads
	var left_rect = Rect2(get_node("left").get_pos() - pad_size * 0.5, pad_size)
	var right_rect = Rect2(get_node("right").get_pos() - pad_size * 0.5, pad_size)
	
	#adding movement to the ball
	ball_pos += direction * ball_speed * delta
	
	#test ball collition
	#flip when touching roof or floor
	if((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y
	#if the ball touched the pads, flip it x direction and define random y direction and increase its speed
	if((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x  = -direction.x
		direction.y = randf()*2.0 -1
		direction = direction.normalized()
		ball_speed *= 1.1
	
	#left goal
	if(ball_pos.x < 0):
		ball_pos = screen_size*0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(1,0)
		score_right = score_right + 1
		get_node("score_right").set_text("Right : " + str(score_right)) 
	#right goal
	if(ball_pos.x > screen_size.x):
		ball_pos = screen_size*0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1,0)
		score_left = score_left + 1
		get_node("score_left").set_text("Left : " + str(score_left))
	#update the ball node with the new position
	get_node("ball").set_pos(ball_pos)
	
	#set player control
	#left player
	var left_pos = get_node("left").get_pos()
	if(left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
		left_pos.y += -PAD_SPEED * delta
	if(left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y += PAD_SPEED * delta
	get_node("left").set_pos(left_pos);
	#right player
	var right_pos = get_node("right").get_pos()
	if(right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
		right_pos.y += -PAD_SPEED * delta
	if(right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		right_pos.y += PAD_SPEED * delta
	get_node("right").set_pos(right_pos)