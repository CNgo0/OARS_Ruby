# =================================================================== #
#   Dear Ruby developer reading this,                                 #
#   please notice my blatant disregard for Ruby's style guidelines.   #
#   I do not like them.                                               #
#                                                                     #
#   Sincerely, an evil nonconformist developer                        #
# =================================================================== #

# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'securerandom'
require_relative "oars/version"
require_relative 'oars/oars_configuration'
require_relative 'oars/oars_result'

module Oars
  EOL = "\r\n"
  
  OARS_URL = 'https://apps-nefsc.fisheries.noaa.gov/oars/'
  OARS_URI = URI.parse(OARS_URL)
  
  module ApiEnv
    Development = 0
    Production = 1
  end
  
  module DbEnv
    Development = 0
    Production = 1
  end
  
  class << self
    def build_form_base(config)
      api_env = ''
      api_env = 'DEVELOPMENT' if config.api_env == 0
      api_env = 'PRODUCTION' if config.api_env == 1
      raise('Invalid OARS API Environment') if(api_env.empty?)
      
      db_env = '' 
      db_env = 'DEVELOPMENT' if config.db_env == 0
      db_env = 'PRODUCTION' if config.db_env == 1
      raise('Invalid OARS Database Environment') if(db_env.empty?)
      
      form = {}
      form['PROJECT'] = config.project
      form['KEY'] = config.key
      form['API_ENV'] = api_env
      form['DB_ENV'] = db_env
      
      return form
    end
    
    def download(config, filename)        
      form = build_form_base(config)
      form['TYPE'] = 'file'
      form['FILENAME'] = filename
      response = Net::HTTP.post_form(OARS_URI, form)
      
      return OarsResult.new(response)
    end
    
    def upload(config, filename, contents)
      form = build_form_base(config)
      form['FILENAME'] = File.basename(filename)
      form['TYPE'] = 'store'
      
      boundary = SecureRandom.uuid
      
      body = []
      form.each do |key, value|
        body << "--#{boundary}#{EOL}"
        body << "Content-Type: text/plain; charset=utf-8#{EOL}"
        body << "Content-Disposition: form-data; name=#{key}#{EOL}"
        body << "#{EOL}"
        body << "#{form[key]}#{EOL}"
      end
      
      body << "--#{boundary}#{EOL}"
      body << "Content-Disposition: form-data; name=FILE; filename=#{form['FILENAME']}; filename*=utf-8''#{form['FILENAME']}#{EOL}"
      body << "#{EOL}"
      body << "#{contents}#{EOL}"
      body << "--#{boundary}--#{EOL}#{EOL}"
      body = body.join()
      
      http = Net::HTTP.new(OARS_URI.host, OARS_URI.port)
      http.use_ssl = true
      
      request = Net::HTTP::Post.new(OARS_URI.path, {'Content-Type' => "multipart/form-data; boundary=\"#{boundary}\""})
      request.body = body
      
      response = http.request(request)
      
      return OarsResult.new(response)
    end
    
    def upload_json(config, filename, contents)
      form = build_form_base(config)
      form['FILENAME'] = File.basename(filename)
      
      boundary = SecureRandom.uuid
      
      body = []
      form.each do |key, value|
        body << "--#{boundary}#{EOL}"
        body << "Content-Type: text/plain; charset=utf-8#{EOL}"
        body << "Content-Disposition: form-data; name=#{key}#{EOL}"
        body << "#{EOL}"
        body << "#{form[key]}#{EOL}"
      end
      
      body << "--#{boundary}#{EOL}"
      body << "Content-Disposition: form-data; name=FILE; filename=#{form['FILENAME']}; filename*=utf-8''#{form['FILENAME']}#{EOL}"
      body << "#{EOL}"
      body << "#{contents}#{EOL}"
      body << "--#{boundary}--#{EOL}#{EOL}"
      body = body.join()
      
      http = Net::HTTP.new(OARS_URI.host, OARS_URI.port)
      http.use_ssl = true
      
      request = Net::HTTP::Post.new(OARS_URI.path, {'Content-Type' => "multipart/form-data; boundary=\"#{boundary}\""})
      request.body = body
      
      response = http.request(request)
      
      return OarsResult.new(response)
    end
  end
end
