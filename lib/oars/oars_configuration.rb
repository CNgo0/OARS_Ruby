class OarsConfiguration
  attr_accessor :project
  attr_accessor :key
  attr_accessor :api_env
  attr_accessor :db_env
  
  def to_hash()
    return {
      'project' => @project,
      'key' => @key,
      'api_env' => @api_env,
      'db_env' => @db_env
      }
  end
  
  def initialize(project, key)
    @project = project
    @key = key
    @api_env = Oars::ApiEnv::Production
    @db_env = Oars::DbEnv::Production
  end
  
  def set_environment(api_env, db_env)
    @api_env = api_env
    @db_env = db_env
  end
end