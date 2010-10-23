# encoding: utf-8

class Scene
  attr_accessor :id, :description, :options, :actions
  
  def initialize(id,description="Generic Scene",options={},actions={})
    @id, @description, @options, @actions = id, description, options, actions
  end
  
  def read_scene
    puts "","# #{@id}", ""
    puts @description, ""
    
    @options.to_a.each {|op| puts "ø #{op[1]}\t(#{op[0]})" }
  end
  
  def title(string)
    @description = string
  end
  
  def option(symbol, description)
    @options.store symbol, description
  end
  
  def action(name, object, description, target=nil, &blk)
    @actions.store name, {
      object => {
        :description => description,
        :target      => target,
        :modifier    => blk
      }
    }
  end
  
  def do_action(name, object, msg, &blk)
    object = object.to_sym

    exists = false
    actions.each_value {|value| exists = true unless value[object].nil? }
    
    if !exists
      puts "That doesn't even exist."
      return
    end
    
    if actions[name].nil?
      puts "Nope, sorry."
      return
    end
    
    if actions[name][object].nil?
      puts msg
      return
    end

    blk.call(object) if blk
    puts actions[name][object][:description]
  end
  
  def look_at(object)
    msg = "Try as you might, you ain't gonna see it."
    do_action(:look_at, object, msg)
  end
  
  def pick_up(object)
    msg = "I won't use my hands on that."

    do_action(:pick_up,object,msg) do |obj|
      mod = actions[:pick_up][obj][:modifier]
      mod.call(self) if mod
    end
  end

  def use(object)
    object = object.to_sym
    object = actions[:use][object]
    
    msg = "You can't use that, silly goose."

    if object.nil?
      puts "You can't use that, silly goose."
      return
    end
    
    if object[:target]==false
      puts "You can't use that yet."
      return
    end
    
    puts object[:description]

    mod = object[:modifier]
    mod.call(self) unless mod.nil?
  end

  def go(path)
#    direction = actions[:go][path.to_sym]

#    if direction.nil?
#      puts "That's not a place you want to go. Trust me."
#      return
#    end
    
    msg = "That's not a place you want to go. Trust me."
    direction = nil
    do_action(:go, path, msg) do |obj|
      direction = actions[:go][obj][:target]
    end

    direction
  end
  alias_method :move, :go

  def method_missing symbol, *args
    puts "I don't know how to do that... Dave."
  end
  
end