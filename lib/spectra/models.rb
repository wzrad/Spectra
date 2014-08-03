
require 'spectra/extensions'
require 'spectra/components'
require 'spectra/dsl'

module Spectra

  class Root
    
    attr_accessor :_prefix
    attr_accessor :colors, :serializers

    include DSL

    def generate(definition) 
      self.instance_eval(definition)
      self.formats(:palette, :objc) unless self.serializers

      self.serializers.each do |serializer|
        serializer.serialize({
          colors: self.colors,
          prefix: self._prefix,  
        })
      end
    end 

  end

  class Color
    
    attr_accessor :name, :components
   
    def initialize(name, components)
      self.name = name
      self.components = components
    end 

    def respond_to?(name)
      super || Components.valid?(name)
    end

    def method_missing(name)
      Components.valid?(name) ? self.components[name] : super
    end

    ##
    ## Debugging
    ##

    def to_s
      "<color: #{name} colors: #{components.values_at(:red, :green, :blue, :alpha).map{|v| v.is_a?(String) ? v : '%.2f' % (v || 0.0) }}>" 
    end

  end

end
