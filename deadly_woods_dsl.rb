require 'pp'
require './lib/scene.rb'
require './lib/world.rb'

game = World.new(
  "Scott Thomas and the Revolving Door",
  "Enter the world of Scott Thomas. But beware, it is not a road easily traveled.

     _______
    /______/|
   | .  . | |
   | .  . | |
   | -  - | |
___|______|/___"
)

game.dsl_add_scene(:introduction) do

  title "Welcome to the game.\nA short description follows."

  option :frog,  "You kill a frog.\t\t\t"
  option :key,   "You see a key on the floor.\t\t"
  option :north, "There is a road leading to some woods.    "

  action :look_at, :frog, 'You see a dead frog.'
  action :pick_up, :key,  'You pick the key.' do |scn|
        scn.option :key, "The key feels heavy in your hand.\t"
        scn.actions[:use][:key][:target] = true
  end
  action :go, :north, 'You trod towards the woods.', :woods
  action :use, :key, "A magic gate unfolds before your eyes.", false do |scn|
      scn.options.store :south, "The magic gate looms...\t\t"
      scn.actions[:go].store :south, {
        :description => "You enter through the magic gate.",
        :target      => :woods
      }
      scn.options.delete :key
  end
  action :use, :frog, "You make a lucky charm for your key ring. Ew ew ew." do |scn|
    scn.options.delete :frog
  end

end

game.dsl_add_scene(:woods) do
  
  title "You are at the woods. Finally.\n\n  ... You die."
  
  option :back, "Go back in time."
  option :exit, "Retire to aetherland."
  
  action :go, :back, "Death carefully inverts your hourglass for a couple of seconds.", :introduction
end

game.start
