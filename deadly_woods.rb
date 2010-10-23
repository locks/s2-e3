require 'pp'
require './lib/scene.rb'
require './lib/world.rb'

game = World.new("--Scott Thomas and the Revolving Door--")

game.bladd_scene(:introduction) do

  description "Welcome to the game.\nA short description follows."

  option :frog,  "You kill a frog.\t\t\t"
  option :key,   "You see a key on the floor.\t\t"
  option :north, "There is a road leading to some woods"

  action :look_at, :frog, 'You see a dead frog.'
  action :pick_up, :key,  'You pick the key.' do |scn|
        scn.options.store :key, "The key feels heavy in your hand.\t"
        scn.actions[:use][:key][:picked] = true
  end
  action :go, :north, 'You trod towards the woods.', :woods
  action :use, :key,   "A magic gate unfolds before your eyes." do |scn|
      scn.options.store :south, "The magic gate looms...\t\t\t"
      scn.actions[:go].store :south, {
        :description => "You enter through the magic gate.",
        :target      => :woods
      }
  end
  action :use, :frog, "You make a lucky charm for your key ring. Ew ew ew.", lambda {|scn| scn.options.delete :frog }
end

game.bladd_scene(:woods) do
  
  description "You are at the woods. Finally.\n\n  ... You die."
  
  option :back, "Go back in time."
  option :exit, "Retire to aetherland."
  
  action :go, :back, "Death carefully inverts your hourglass for a couple of seconds.", :introduction
end

old_game = World.new("Another One")
old_game.add_scene(
  :introduction,
  "Welcome to the game.
A short Description follows.",
  {
    :frog  => "You kill a frog.\t\t\t",
    :key   => "You see a key on the floor.\t\t",
    :north => "There is a road leading to some woods."
  },
  {
    :look_at => {
      :frog => {
        :description => 'You see a dead frog.'
      }
    },
    :pick_up => {
      :key  => {
        :description => 'You pick the key.',
        :modifier => lambda{|scene|
          scene.options.store(:key, "The key feels heavy in your hand.\t")
          scene.actions[:use][:key][:picked] = true
        }
      }
    },
    :go => {
      :north => {
        :description => "You trod towards the woods",
        :target      => :woods
      }
    },
    :use => {
      :key => {
        :description => "A magic gate unfolds before your eyes.",
        :modifier => lambda do |scn|
          scn.options.store(:south, "The magic gate looms\t\t\t")
          scn.actions[:go].store(:south, {
              :description => "You enter through the magic ",
              :target      => :woods
          })
          scn.options.delete :key
        end,
        :picked => false
      },
      :frog => {
        :description => "You make a lucky charm for your key ring. Ew ew ew.",
        :modifier => lambda {|scn| scn.options.delete :frog }
      }
    }
  }
)

old_game.add_scene(
  :woods,
  "You are at the woods. Finally.

  ... You die.",
  {
    :back => "Go back in time.",
    :exit => "Exit the game."
  },
  {
    :go => {
      :back => {
        :description => "Death slowly turns back your hourglass.",
        :target      => :introduction
      }
    }
  }
)

=begin
File.open('game_dump.txt','w') {|file|
  file.write game.inspect
  file.write old_game.inspect
}
=begin
=end

pp game
pp old_game

#game.start
old_game.start
