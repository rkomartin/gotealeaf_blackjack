# Constants section

DECK_SIZE = 56
PER_SUITE = 14
BLACKJACK_VAL = 21
DEALER_LIM = 17

FREE = 0
TAKEN = 1

SUITS = %w[hearts spades clubs diamonds]
SUIT_NAMES = {11 => "Ace", 12 => "Jack", 13 => "Queen", 14 => "King"}

# Helper methods section

def init_deck
  for i in 0..DECK_SIZE - 1 do
    
    #No Ones in the deck, mark them as taken already

    if i % PER_SUITE == 0
      $deck[i] = TAKEN
    else 
      $deck[i] = FREE
    end
  end
end

def deal_hand
  dealt = 0
  
  while dealt == 0 do
    shot = rand(DECK_SIZE)
    if $deck[shot] == FREE
      $deck[shot] = TAKEN
      dealt = shot
    end
  end
  
  d_value = dealt % PER_SUITE + 1
  d_suite = SUITS[dealt / PER_SUITE]

  if d_value > 10
    d_name = SUIT_NAMES[d_value]
    d_value = 10 if d_value != 11
  else
    d_name = d_value.to_s
  end

  return d_value, d_suite, d_name
end

def hand_sum(hand)
  hand.inject {|sum, x| sum + x }
end

def aces_adjust(hand)
  tmp_array = hand
  idx = 0

  while idx < tmp_array.length && hand_sum(tmp_array) > BLACKJACK_VAL do
    if tmp_array[idx] == 11
      tmp_array[idx] = 1
    end
    idx += 1
  end
  
  tmp_array
end

# Game init section

print "Your name:"
player_name = gets.chomp
puts "Hello, #{player_name}!"
puts

player_score = 0
dealer_score = 0
game_over = false
$deck = Array.new(DECK_SIZE)

# Main game loop

until game_over do

  init_deck
  player_hand = []
  dealer_hand = []
  round_over = false

  # Round loop

  until round_over do

    # First two cards dealt

    ph1  = deal_hand
    dh1  = deal_hand
    ph2  = deal_hand
    dh2  = deal_hand
 
    puts "You have been dealt:\n#{ph1[2]} of #{ph1[1]}\n#{ph2[2]} of #{ph2[1]}"
    puts "\nDealer has been dealt:\n#{dh1[2]} of #{dh1[1]}\n#{dh2[2]} of #{dh2[1]}"

    player_hand << ph1[0] << ph2[0]
    dealer_hand << dh1[0] << dh2[0]

    ph_sum = hand_sum(player_hand)
    dh_sum = hand_sum(dealer_hand)

    # Player loop
  
    loop do
      player_hand = aces_adjust(player_hand)
      ph_sum = hand_sum(player_hand)

      puts "\nYou have #{ph_sum}"
      puts "Dealer has #{dh_sum}"

      if ph_sum > BLACKJACK_VAL
        puts "\nSorry, #{player_name}, you're busted!"
        dealer_score += 1
        round_over = true
        break

      elsif ph_sum == BLACKJACK_VAL
        puts "\nWow! Blackjack, #{player_name}! You win!"
        player_score += 1
        round_over = true
        break

      else
        puts "Your move (Hit/Stay)"
      end

      mv = gets.chomp
      if mv =~ /s/i
        break

      elsif mv =~/h/i
        ph  = deal_hand

        puts "\nYou have been dealt:"
        puts "#{ph[2]} of #{ph[1]}"
        
        player_hand << ph[0]
        ph_sum = hand_sum(player_hand)

      else 
        puts "\nWrong choice. Please choose again"

      end
    end

    if round_over then break
    end

    # Dealer loop

    loop do
      dealer_hand = aces_adjust(dealer_hand)
      dh_sum = hand_sum(dealer_hand)
      
      puts "\nYou have #{ph_sum}"
      puts "Dealer has #{dh_sum}"
      
      if dh_sum > BLACKJACK_VAL
        puts "\nYou win #{player_name}, I'm busted!"
        player_score += 1
        round_over = true
        break

      elsif dh_sum == BLACKJACK_VAL
        puts "\nSorry #{player_name} - I have a Blackjack! I win!"
        dealer_score += 1
        round_over = true
        break

      else
        puts "\nMy turn"
      end

      if dh_sum < DEALER_LIM || dh_sum <= ph_sum

        dh  = deal_hand

        puts "\nI have been dealt:"
        puts "#{dh[2]} of #{dh[1]}"
        
        dealer_hand << dh[0]
        dh_sum = hand_sum(dealer_hand)

      else 
        puts "I have #{dh_sum} and I stay!"
        puts
        break

      end
    end
    
    if round_over then break
    end

    # Final comparison of the hands

    if ph_sum > dh_sum
      puts "You win with #{ph_sum} against #{dh_sum}"
      player_score += 1

    elsif ph_sum < dh_sum
      puts "I win with #{dh_sum} against #{ph_sum}"
      dealer_score += 1

    else
      puts "It's a tie at #{ph_sum}"
    
    end

    round_over = true

  end

  puts "\nOverall score:"
  puts " #{player_name}: #{player_score}\n Dealer: #{dealer_score}"
  puts "\nWanna play again?"
  if gets.chomp =~ /n/i
    game_over = true
  end
end

puts "\nBye #{player_name}!"