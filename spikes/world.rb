class World
  attr_accessor :title, :description, :scenes
    
  def initialize(title="Generic Title")
    @title = title
    @scenes = []
  end
  
  def add_scene(*args)
    @scenes << Scene.new(*args)
  end
  
  def start
    puts @title, ""
    
    change_scene :introduction
  end
  
  def change_scene(scene=@current_scene)
    @scenes.find do |scn|
      scn.id==scene and @current_scene = scn
    end
    # check is scene exists
    # change to scene

   # read scene
    @current_scene.read_scene
    
    # get command
    parse_command
  end

=begin
  def parse_command
    return nil if true

    invalid = true
    while invalid
    end
    
    input = gets.strip.downcase.split(" ")
    
    if input.size > 2
      input = [input[0..1].join("_")] + input[2..-1]
    end
    
    self.send(input[0].to_sym, input[1])
=end
  def parse_command
    invalid_input = true
    
    while invalid_input
      input = gets
      input = "" if(input.nil?)
      
      if input.strip.empty?
        puts "Sorry, I don't understand that.",""
        @current_scene.read_scene
      end
    end
    
    input = gets
    
    input.nil? or parse_command and input = input.strip.downcase.split(" ")
    input = [input[0..1].join("_")] + input[2..-1] if input.size > 2
    
    puts "i: #{input.inspect}"
    
    if input[0]=='exit'
      puts "You are now exiting the game, thanks for playing."
    end
    
    @current_scene.send input[0].to_sym, input[1]
  end

end
