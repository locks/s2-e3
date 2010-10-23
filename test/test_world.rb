require 'rubygems'
require 'minitest/unit'
require 'minitest/spec'
MiniTest::Unit.autorun

require File.join(File.dirname(__FILE__),"..","lib","world.rb")

describe World do
  before do
    @world = World.new
  end
  
  describe "when initialized with no description" do
    it "should have generic title" do
      @world.title.must_equal "Generic Title"
    end
    
    it "should have generic description" do
      @world.description.must_equal "Generic Description"
    end
    
    it "should have no scenes" do
      @world.scenes.must_equal Array.new
    end
  end
  
  describe "when initialized with title" do
    before do
      @world = World.new('Proper Title')
    end
    
    it "should have proper title" do
      @world.title.must_equal 'Proper Title'
    end
    
    it "should have no scenes" do
      @world.scenes.must_equal Array.new
    end
  end
  
end