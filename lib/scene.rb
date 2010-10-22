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
  
  def description(string)
    @description = string
  end
  
  def option(symbol, description)
    @options.store symbol, description
  end
  
  def action(action, object, description, target=nil, &blk)
    @actions[action] = {
      object => { :description, description }
    }

    @actions[action][object].store :target, target unless target.nil?
    @actions[action][object].store :modifier, blk unless blk.nil?
  end
  
  def look_at(target)
    target = target.to_sym
    sight = actions[:look_at][target][:description]
    
    if sigh.nil?
      puts "Try as you might, you ain't gonna see it."
      return
    end
    
    puts sight[:description]
  end
  
  def pick_up(target)
    target = target.to_sym
    
    puts actions[:pick_up][target][:description]

    mod = actions[:pick_up][target][:modifier]
    mod.call(self) if !mod.nil?
  end

  def use(target)
    target = target.to_sym
    object = actions[:use][target]
    
    if object.nil?
      puts "You can't use that, silly goose."
      return
    end
    
    if object[:picked]==false
      puts "You can't use that yet."
      return
    end
    
    puts object[:description]

    mod = object[:modifier]
    mod.call(self) if !mod.nil?
  end

  def go(target)
    direction = actions[:go][target.to_sym]

    if direction.nil?
      puts "That's not a place you want to go. Trust me."
      return
    end

    puts direction[:description]
    direction[:target]
  end
  alias_method :move, :go

  def method_missing symbol, *args
    puts "I don't know how to do that... Dave."
  end
  
end