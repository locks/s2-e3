require 'pp'
require './lib/scene.rb'
require './lib/world.rb'

game = World.new(
  "Scott Thomas and the Revolving Door",
  "Enter the world of Scott Thomas. But beware, it is not a road easily traveled"
)
game.add_scene(
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
          scene.actions[:use][:key][:target] = true
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
        :target => false
      },
      :frog => {
        :description => "You make a lucky charm for your key ring. Ew ew ew.",
        :modifier => lambda {|scn| scn.options.delete :frog }
      }
    }
  }
)

game.add_scene(
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

game.start
