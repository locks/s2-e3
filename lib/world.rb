class World
  attr_accessor :title, :description, :scenes
    
  def initialize(title="Generic Title", description="Generic Description", scenes=[])
    @title       = title
    @description = description
    @scenes      = scenes
  end
  
  def add_scene(*args)
    @scenes << Scene.new(*args)
  end
  
  def dsl_add_scene(key, &block)
    scn = Scene.new(key)
    scn.instance_eval &block
    
    @scenes << scn
  end
  
  def start
    puts "--#{@title}--", ""
    puts @description, ""
    
    switch_scene :introduction
    parse_command
  end
  
  def switch_scene(scene)
    @scenes.find do |scn|
      scn.id==scene and @current_scene = scn
    end
  end
  
  def go(direction)
    switch_scene @current_scene.go(direction)
  end

  def parse_command
  while true
    @current_scene.read_scene
  
    print "> "
    input = gets.to_s.strip.downcase.split(" ")
  
    if input.empty?
      puts "Sorry, I don't understand that",""
      next
    end

    if input[0] == 'exit'
      puts "Thank you for playing.", "Exiting... or am I...?"
      exit
    end
  
    if input.size > 2
      input = [input[0..1].join("_")] + input[2..-1]
    end
  
    self.send input[0].to_sym, input[1]
  end
  end
  
  def method_missing(symbol, *args)
    @current_scene.send symbol, *args
  end

end
