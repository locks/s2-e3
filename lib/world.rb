class World
  attr_accessor :title, :description, :scenes, :output
    
  def initialize(title="Generic Title", description="Generic Description", scenes=[], output=STDOUT)
    @title, @description, @scenes = title, description, scenes
    
    @output = output
  end
  
  def add_scene(key, &block)
    scn = Scene.new(key)
    scn.instance_eval(&block)
    scn.output = @output
    
    @scenes << scn
  end
  
  def start
    say("--#{@title}--", "")
    say(@description, "")
    
    switch_scene :introduction
    parse_command
  end
  
  def switch_scene(scene)
    @scenes.find do |scn|
      scn.id==scene and @current_scene = scn
    end
  end

  def parse_command
    while true
      @current_scene.read_scene
  
      print "> "
      input = gets.to_s.strip.downcase.split(" ")
  
      if input.empty?
        say("Sorry, I don't understand that","")
        next
      end

      if input[0] == 'exit'
        say("Thank you for playing.", "Exiting... or am I...?")
        exit
      end
  
      if input.size > 2
        input = [input[0..1].join("_")] + input[2..-1]
      end

      if input[0] == 'go'
        switch_scene @current_scene.go(input[1])
      else
        @current_scene.send input[0], input[1]
      end
    end
  end
  
  def say(*msg)
    @output.puts(msg)
  end

end
