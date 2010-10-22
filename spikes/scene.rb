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