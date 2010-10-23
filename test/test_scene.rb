require 'rubygems'
require 'minitest/unit'
require 'minitest/spec'
MiniTest::Unit.autorun

require File.join(File.dirname(__FILE__),"../lib","scene.rb")

#class TestScene < MiniTest::Unit::TestCase

describe Scene do  
  before do
    @scene = Scene.new(:testing)
  end
  
  describe 'when initialized with only id' do
    it "should have generic description" do
      @scene.description.must_equal "Generic Scene"
    end
    
    it "should not have options" do
      @scene.options.must_equal Hash.new
    end
    
    it "should not have actions" do
      @scene.actions.must_equal Hash.new
    end
  end
  
  describe 'when an option is added' do
    it "should register the option with description" do
      @scene.option :key, "You see a key on the floor."
      
      wont_be_nil @scene.options[:key]
      @scene.options[:key].must_equal "You see a key on the floor."
    end
  end
end