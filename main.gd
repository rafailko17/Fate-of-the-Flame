extends Control

# Grab references to our UI nodes
@onready var score_label = $ScoreLabel
@onready var win_label = $WinLabel
@onready var play_again_button = $PlayAgainButton
@onready var cards = [$HBoxContainer/Card1, $HBoxContainer/Card2, $HBoxContainer/Card3]

# Game variables
var score: int = 0
var card_values: Array = ["FIRE", "NOPE", "NOPE"]
var is_waiting: bool = false

func _ready():
	# Connect each card's click signal
	for i in range(cards.size()):
		cards[i].pressed.connect(_on_card_clicked.bind(i))
	
	# Connect the Play Again button's click signal
	play_again_button.pressed.connect(_on_play_again_pressed)
	
	start_new_round()

func start_new_round():
	card_values.shuffle()
	
	for card in cards:
		card.text = "?"
		card.disabled = false
		
	is_waiting = false

func _on_card_clicked(index: int):
	if is_waiting:
		return
		
	is_waiting = true
	
	for card in cards:
		card.disabled = true
	
	# Reveal the chosen card
	var chosen_value = card_values[index]
	cards[index].text = chosen_value
	
	# Update the score
	if chosen_value == "FIRE":
		score += 10
	else:
		score -= 2
		if score < 0:
			score = 0
			
	score_label.text = "SCORE: " + str(score)
	
	# Check win condition
	if score >= 70:
		win_label.visible = true
		play_again_button.visible = true # Show the Play Again button
		for i in range(cards.size()):
			cards[i].text = card_values[i]
		return
	
	await get_tree().create_timer(1.0).timeout
	start_new_round()

func _on_play_again_pressed():
	# Reset score and update the text
	score = 0
	score_label.text = "SCORE: 0"
	
	# Hide the win text and button again
	win_label.visible = false
	play_again_button.visible = false
	
	# Start fresh
	start_new_round()
