# Constants section

$DECK_SIZE = 56
$PER_SUITE = 14
$BLACKJACK_VAL = 21
$DEALER_LIM = 17

$FREE = 0
$TAKEN = 1

$SUITS = ["hearts", "spades", "clubs", "diamonds"]
$SUIT_NAMES = {11 => "Ace", 12 => "Jack", 13 => "Queen", 14 => "King"}

# Helper methods section

def init_deck
  for i in 0..$DECK_SIZE - 1 do
		
    #No Ones in the deck, mark them as taken already

    if i % $PER_SUITE == 0
			$deck[i] = $TAKEN
		else 
			$deck[i] = $FREE
		end
	end
end

def deal_hand
	dealt = 0
	
	while dealt == 0 do
		shot = rand($DECK_SIZE)
		if $deck[shot] == $FREE
			$deck[shot] = $TAKEN
			dealt = shot
		end
	end
	
	d_v = dealt % $PER_SUITE + 1
	d_s = $SUITS[dealt / $PER_SUITE]

	if d_v > 10
		d_n = $SUIT_NAMES[d_v]
		d_v = 10 if d_v != 11
	else
		d_n = d_v.to_s
	end

	return d_v, d_s, d_n
end

def hand_sum(hand)
	return hand.inject {|sum, x| sum + x }
end

def aces_adjust(hand)
	tmp_array = hand
	idx = 0

	while idx < tmp_array.length && hand_sum(tmp_array) > $BLACKJACK_VAL do
		if tmp_array[idx] == 11
			tmp_array[idx] = 1
		end
		idx += 1
	end
	
	return tmp_array
end

# Game init section

print "Your name:"
player_name = gets.chomp
puts "Hello, #{player_name}!"
puts

game_over = false
$deck = Array.new($DECK_SIZE)

# Main game loop

until game_over do

  init_deck
  player_hand = []
  dealer_hand = []
  round_over = false

	# Round loop

  until round_over do

  	# First two cards dealt

  	ph1_v, ph1_s, ph1_n  = deal_hand
  	ph2_v, ph2_s, ph2_n  = deal_hand
  	dh1_v, dh1_s, dh1_n  = deal_hand
  	dh2_v, dh2_s, dh2_n  = deal_hand
 
   	puts "You have been dealt:"
  	puts "#{ph1_n} of #{ph1_s}"
  	puts "#{ph2_n} of #{ph2_s}"
  	puts

  	puts "Dealer has been dealt:"
  	puts "#{dh1_n} of #{dh1_s}"
  	puts "#{dh2_n} of #{dh2_s}"

  	player_hand << ph1_v << ph2_v
  	dealer_hand << dh1_v << dh2_v

  	p_h_sum = hand_sum(player_hand)
  	d_h_sum = hand_sum(dealer_hand)

  	# Player loop
	
  	loop do
  		player_hand = aces_adjust(player_hand)
   		p_h_sum = hand_sum(player_hand)

  		puts "\nYou have #{p_h_sum}"
  		puts "Dealer has #{d_h_sum}"

  		if p_h_sum > $BLACKJACK_VAL
  			puts "\nSorry, #{player_name}, you're busted!"
  			round_over = true
  			break

  		elsif p_h_sum == $BLACKJACK_VAL
  			puts "\nWow! Blackjack, #{player_name}! You win!"
  			round_over = true
  			break

  		else
  			puts "Your move (Hit/Stay)"
  		end

  		mv = gets.chomp
  		if mv =~ /s/i
  			break

  		elsif mv =~/h/i
  			ph_v, ph_s, ph_n  = deal_hand

   			puts "\nYou have been dealt:"
  			puts "#{ph_n} of #{ph_s}"
  			
  			player_hand << ph_v
				p_h_sum = hand_sum(player_hand)

  		else 
  			puts "\nWrong choice. Please choose again"

  		end
  	end

  	if round_over then break
  	end

  	# Dealer loop

  	loop do
  		dealer_hand = aces_adjust(dealer_hand)
  		d_h_sum = hand_sum(dealer_hand)
  		
  		puts "\nYou have #{p_h_sum}"
  		puts "Dealer has #{d_h_sum}"
  		
  		if d_h_sum > $BLACKJACK_VAL
  			puts "\nYou win #{player_name}, I'm busted!"
  			round_over = true
  			break

  		elsif d_h_sum == $BLACKJACK_VAL
  			puts "\nSorry #{player_name} - I have a Blackjack! I win!"
  			round_over = true
  			break

  		else
  			puts "\nMy turn"
  		end

  		if d_h_sum < $DEALER_LIM || d_h_sum <= p_h_sum

  			dh_v, dh_s, dh_n  = deal_hand

   			puts "\nI have been dealt:"
  			puts "#{dh_n} of #{dh_s}"
  			
  			dealer_hand << dh_v
				d_h_sum = hand_sum(dealer_hand)

  		else 
  			puts "I have #{d_h_sum} and I stay here!"
  			puts
  			break

  		end
  	end
  	
  	if round_over then break
  	end

  	# Final comparison of the hands

  	if p_h_sum > d_h_sum
  		puts "You win with #{p_h_sum} against #{d_h_sum}"

  	elsif p_h_sum < d_h_sum
  		puts "I win with #{d_h_sum} against #{p_h_sum}"

  	else
  		puts "It's a tie at #{p_h_sum}"
  	
  	end

  	round_over = true

  end

  puts "Wanna play again?"
  if gets.chomp =~ /n/i
		game_over = true
	end
end

puts "\nBye #{player_name}!"