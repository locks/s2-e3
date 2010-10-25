# encoding: utf-8

class Scene
  attr_accessor :id, :description, :options, :actions, :output
  
  def initialize(id,description="Generic Scene",options={},actions={},output=STDOUT)
    @id, @description, @options, @actions = id, description, options, actions
    
    @output = output
  end
  
  def read_scene
    say("","# #{@id}", "")
    say(@description, "")
    
    @options.to_a.each {|op| say("ø #{op[1]}\t(#{op[0]})") }
  end
  
  def describe(string)
    @description = string
  end
  
  def option(symbol, description)
    @options.store symbol, description
  end
  
  def action(name, object, description, target=nil, &blk)
    
    if @actions[name]
      @actions[name].store object, {
        :description => description,
        :target      => target,
        :modifier    => blk
      }
    else
    @actions.store name, {
      object => {
        :description => description,
        :target      => target,
        :modifier    => blk
    }}
    end
  end
  
  def execute_action(name, object, msg, &blk)
    object = object.to_sym

    exists = false
    actions.each_value {|value| exists = true unless value[object].nil? }
    
    if !exists
      say("That doesn't even exist.")
      return
    end
    
    if actions[name].nil?
      say("Nope, sorry.")
      return
    end
    
    if actions[name][object].nil?
      say(msg)
      return
    end

    blk.call(object) if blk
    say(actions[name][object][:description])
  end
  
  def look_at(object)
    msg = "Try as you might, you ain't gonna see it."
    execute_action(:look_at, object, msg)
  end
  
  def pick_up(object)
    msg = "I won't use my hands on that."

    execute_action(:pick_up,object,msg) do |obj|
      mod = actions[:pick_up][obj][:modifier]
      mod.call(self) if mod
    end
  end

  def use(object)
    object = object.to_sym
    object = actions[:use][object]

    if object.nil?
      say("You can't use that, silly goose.")
      return
    end
    
    if object[:target]==false
      say("You can't use that yet.")
      return
    end
    
    say(object[:description])

    mod = object[:modifier]
    mod.call(self) unless mod.nil?
  end

  def go(path)
    msg = "That's not a place you want to go. Trust me."
    direction = nil
    execute_action(:go, path, msg) do |obj|
      direction = actions[:go][obj][:target]
    end

    direction
  end
  alias_method :move, :go
  
  def say(*msg)
    @output.puts(msg)
  end
  
end