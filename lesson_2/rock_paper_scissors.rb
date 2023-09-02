require 'yaml'
MESSAGES = YAML.load_file('rps_messages.yml')

VALID_CHOICES = %w(r p ss l sk)

def prompt(message)
  puts "=> #{message}"
end

def introduction(name)
  prompt(MESSAGES['welcome'])
  loop do
    name << gets.chomp
    name.strip!
    if name.empty?()
      prompt(MESSAGES['valid_name'])
    else
      break
    end
  end
  prompt("Hello, #{name}!")
end

def player_choice(choice)
  prompt(MESSAGES['choices'])
  loop do
    choice << gets.chomp
    if VALID_CHOICES.include?(choice)
      break
    else
      prompt(MESSAGES['valid_choice'])
      choice.clear
    end
  end
end

def win?(first, second)
  win = {
    r: ['ss', 'l'],
    p: ['r', 'sk'],
    ss: ['p', 'l'],
    l: ['sk', 'p'],
    sk: ['r', 'ss']
  }
  win[first.to_sym].include?(second)
end

def calculate_winner(player, computer)
  if win?(player, computer)
    'player'
  elsif win?(computer, player)
    'computer'
  else
    'tie'
  end
end

def display_grand_winner(player_score, computer_score)
  if player_score == 3 && computer_score == 3
    prompt(MESSAGES['tied_winners'])
  elsif player_score == 3
    prompt(MESSAGES['grand_winner_player'])
  elsif computer_score == 3
    prompt(MESSAGES['grand_winner_computer'])
  end
end

def validate_answer(answer)
  if answer.downcase == "y" || answer.downcase == "yes"
    true
  elsif answer.downcase == 'n' || answer.downcase == 'no'
    false
  else
    prompt(MESSAGES['valid_answer'])
    answer = gets.chomp
    validate_answer(answer)
  end
end

system("clear")
player_score = 0
computer_score = 0
name = ''
letter_to_word = {
  'r' => 'rock',
  'p' => 'paper',
  'ss' => 'scissors',
  'l' => 'lizard',
  'sk' => 'spock'
}
introduction(name)
loop do # main loop
  choice = ''
  computer_choice = VALID_CHOICES.sample
  player_choice(choice)
  prompt("You chose: #{letter_to_word[choice]}.")
  prompt("Computer chose: #{letter_to_word[computer_choice]}.")
  winner = calculate_winner(choice, computer_choice)
  if winner == 'player'
    prompt("#{name} won!")
    player_score += 1
  elsif winner == 'computer'
    prompt(MESSAGES['computer_won'])
    computer_score += 1
  else
    prompt(MESSAGES['tied'])
    player_score += 1
    computer_score += 1
  end
  prompt("Your score is: #{player_score}.")
  prompt("Computer's score is: #{computer_score}.")
  display_grand_winner(player_score, computer_score)
  if player_score == 3 || computer_score == 3
    player_score = 0
    computer_score = 0
  end
  prompt(MESSAGES['play_again'])
  answer = gets.chomp
  break unless validate_answer(answer)
end

prompt("Thank you for playing, #{name}. Good-bye!")
