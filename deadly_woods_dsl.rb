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
  title "

   V  #    WwW     www
...|-_|-.-.| |-.,,,| |-.-.,-.,.-,-.,

You wake up in the midst of the woods, lying in a clearing.
The midday sun bright in the empty hurts your eyes as you gaze around you for signs of familiarity.
You get up slighly dazed. Something feels odd. A stillness that doesn't seem natural.
You look around again."

  option :frog,  "There's a dead frog at your feet.\t\t\t"
  option :key,   "You see a key on the floor.\t\t"
  option :north, "There is a road leading to some woods.    "

  action :look_at, :frog, 'You see a dead frog.'
  action :look_at, :key, "Seems to be a regular key. Except for the odd..."
  action :pick_up, :frog, 'You pick the frog up.' do |scn|
    scn.option :frog, "You hold a dead frog in your left hand."
    scn.actions[:use][:frog][:target] = true
  end
  action :pick_up, :key,  'You pick the key.' do |scn|
    scn.option :key, "The key feels heavy in your right hand.\t"
    scn.actions[:use][:key][:target] = true
  end
  action :go, :north, 'You trod towards the woods.', :woods
  action :use, :frog, "You make a lucky charm for your key ring. Ew ew ew.", false do |scn|
    scn.options.delete :frog
  end
  action :use, :key, "A magic gate unfolds before your eyes.", false do |scn|
    scn.options.store :south, "The magic gate looms...\t\t"
    action :go, :south, "You draw nearer to the magic gate.", :gate do |scn|
      scn.options.delete :key
    end
  end
end

game.dsl_add_scene(:woods) do
  title "You are at the woods. Finally.\n\n  ... You die."
  
  option :back, "Go back in time."
  option :exit, "Retire to aetherland."
  
  action :go, :back, "Death carefully inverts your hourglass for a couple of seconds.", :introduction
end

game.dsl_add_scene :gate do
  title "
    _____
  ~| . . | ~
 ~ | . . |~. 
___|_____|___

You get closer to the gate.
It's enveloped by this strange shimmer, and fog leaks out from the hinges and the frame."

  option :doorknob, "An exquisite ivory door know adorns the door."
  option :knocker, "A door knocker, shaped like the head of an eagle seems to look intently at you."

  action :use, :doorknob, "It seems jammed. Maybe there's something you need to do first."
  action :use, :knocker, "You strike the knocker. The echoes from the hit seem to ripple forever. The door starts opening." do |scn|
    scn.options.delete :doorknob
    scn.options.delete :knocker
    scn.option :in, "The door to the magic gate is ajar, this is your chance to step in."
    scn.action :go, :in, "You walk into the door to the other side.", :corridor
  end
end

game.dsl_add_scene :corridor do
  title "You blink your eyes. The door behind you disappears at it shuts.
You are in a long corridor, all surfaces shiny white marble. Looking around you ponder, are you in Heaven?
There are 66 doors, 6 feet apart from each other. But a few of them have a label possibly describing where they lead to."

  option :east, "Garden \"Enjoy the botanical natural beauties from around the world Earth.\""
  option :west, "Poppy Field \"Stroll around in this scented hill\""
  
  action :go, :east, "You open the door to the garden feeling the rush of fresh hair and step inside.", :garden
  action :go, :west, "Hesitating you gently push the creeking door to be greated with a rolling hill", :field
end

game.dsl_add_scene :garden do
  title "You can't believe what you eyes are seeing. It frightens you to the core so much you start shaking."
  option :back, "Go back. NOW!"
  option :it, "Or do you dare look at it?"
  
  action :go, :back, "Suddenly scared by what you just saw you hurry back through the door.", :corridor
  action :look_at, :it, "You are shaking too much to turn your head its way." do |scn|
    scn.options.delete :it
  end
end

game.dsl_add_scene :field do
  title "You feel the grass and poppies underneath your feet. It smells great here!
You see a strange beast on the horizon. It looks at you enraged and starts charging.
You turn back to face the door but it's gone.
There are two paths leading away from the foul beast."

  option :south, "You hear the sound of water rushing. Your attacker doesn't seem water friendly."
  option :north, "Up the hill there is a wooden shack. It may hold off the creature."
  
  action :go, :south, "You run down the hill as fast as you can. You fall and tumble down.", :ravine
  action :go, :north, "With heavy breathe you manage to outrun the bloodthirsty creature up the hill.", :woodshack
end

game.dsl_add_scene :woodshack do
  title "You arrive at the door of the shack.
Hearing the fast stomping feet of your chaser you hurry getting inside the house and running the bolt on the door.
The beast pounds on your door for a while and then leaves.
You look around the house."

  option :west, "There seems to be a bathroom to your left."
  option :north, "Further ahead there is a living room. You don't hear a sound."
  
  action :go, :west, "You pinch your nose and venture forth.", :wc
  action :go, :north, "Hoping you catch a break you step into the living room.", :livingroom
end

game.dsl_add_scene :wc do
  title "
 ___
|   |_____.,
|___    __-´
    |  |
    |__|

You are surprised by the lack of smell.
There is nothing here, really."
  
  option :toilet,  "Maybe you need to use the toilet?"
  option :back, "Go back when you are ready."
  
  action :use, :toilet, "You feel much better now." do |scn|
    scn.options.delete :toilet
  end
  action :go, :back, "You return to the hall way.", :woodshack
end

game.dsl_add_scene :livingroom do
  title "It's completely empty and you die. Sorry."
  
  option :death, "Figure this one out yourself."
  action :use, :death, "GOODBYE FOREVER" do |scn| exit end
end

game.dsl_add_scene :ravine do
  title "You see a white wall. The sky is also white in this part.
In fact.. everything is white and blocky..."
  
  option :download, "Buffering..."
  action :use, :download, "You download the rest of the level" do |scn| puts "come back later"; exit end
end

game.dsl_add_scene :river do
end

game.dsl_add_scene :bank do
end

game.dsl_add_scene :trollcamp do
end

game.dsl_add_scene :ghosttown do
end

game.dsl_add_scene :emptyhouse do
end

game.dsl_add_scene :home do
end

game.start
