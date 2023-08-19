LANGUAGE = 'en'
require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')
def messages(message, lang='en')
  MESSAGES[lang][message]
end

def prompt(message)
  puts "=> #{message}"
end

def valid_number?(num)
  num.to_i.to_s == num || num.to_f.to_s == num
end

def delete_period(string)
  if string.end_with?(".")
    string.delete_suffix!(".")
  end
end

def add_zero(string)
  if string.start_with?(".")
    string.prepend("0")
  elsif string.start_with?("-.")
    string.gsub!("-.", "-0.")
  end
end

def operation_to_message(op)
  word =  case op
          when '1'
            messages('add', LANGUAGE)
          when '2'
            messages('subtract', LANGUAGE)
          when '3'
            messages('multiply', LANGUAGE)
          when '4'
            messages('divide', LANGUAGE)
          end
  word
end
num1 = ''
num2 = ''

prompt(messages('welcome', LANGUAGE))

name = ''
loop do
  name = gets.chomp
  if name.empty?()
    prompt(messages('valid_name', LANGUAGE))
  else
    break
  end
end

prompt("Hi, #{name}!")

loop do # main loop
  loop do
    prompt(messages('number_prompt_1', LANGUAGE))
    num1 = gets.chomp
    delete_period(num1)
    add_zero(num1)
    if valid_number?(num1)
      break
    else
      prompt(messages('invalid_number', LANGUAGE))
    end
  end
  loop do
    prompt(messages('number_prompt_2', LANGUAGE))
    num2 = gets.chomp
    delete_period(num2)
    add_zero(num2)
    if valid_number?(num2)
      break
    else
      prompt(messages('invalid_number', LANGUAGE))
    end
  end
  operator_prompt = <<-MSG
    What operation would you like to perform?
    1) add
    2) subtract
    3) multiply
    4) divide
  MSG
  prompt(operator_prompt)
  operator = ''
  loop do
    operator = gets.chomp
    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt(messages('invalid_operator', LANGUAGE))
    end
  end
  prompt("#{operation_to_message(operator)} the two numbers...")
  result =  case operator
            when '1'
              num1.to_f + num2.to_f
            when '2'
              num1.to_f - num2.to_f
            when '3'
              num1.to_f * num2.to_f
            when '4'
              num1.to_f / num2.to_f
            end
  prompt("The result is #{format('%.2f', result)}.")
  prompt(messages('another_operation', LANGUAGE))
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end
prompt(messages('good_bye', LANGUAGE))
