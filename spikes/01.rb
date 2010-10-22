require 'pp'
require 'scene.rb'
require 'world.rb'

=begin
class Scene
  attr_reader :id, :description, :actions
  
  def initialize(id,description="Generic Scene",actions={})
    @id, @description, @actions = id, description, actions
  end
  
  def read_scene
    puts "# #{@id}", ""
    puts @description, ""
  end
  
  def go(target)
    actions[:move][target.to_sym].call
  end
  alias_method :move, :go
  
end


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
=begin
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
=end

game = World.new("--Scott Thomas and the Revolving Door--")

#game.add_scene()
a = Scene.new(
  :introduction,
  "Welcome to the game.
A short Description follows.

ø You kill a frog.                      (frog)
ø You see a key on the floor.           (key)
ø There is a road leading to some wood. (north)",
  {
    :look_at => 'You see a dead frog.',
    :pick_up  => lambda{},
    :move => {
      :north => lambda{ puts "You trod towards the woods"; :woods }
    }
  }
)

pp a.actions[:move][:north].call

game.add_scene(
  :woods,
  "You are at the woods. Finally.

  ... You die."
)

game.add_scene(
  :frog,
  "The frog is died, game is won.
You feel defeated, oh why oh why!",
  [{
    :description => "Repent your sins. (dagger)",
    :target => :silly_death
  },
  {
    :description => "Move forward. (south)",
    :target => :introduction
  }]
)

pp game

#game.start
