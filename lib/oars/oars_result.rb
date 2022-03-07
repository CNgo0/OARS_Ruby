module Oars
  class OarsResult
    attr_accessor :data
    attr_accessor :content_type
    
    def initialize()
      @data = nil
      @content_type = nil
    end
    
    def initialize(response)
      @data = response.body
      @content_type = response['content-type']
    end
    
    def to_hash()
      return {
        'data' => @data,
        'content_type' => @content_type
      }
    end
  end
end
