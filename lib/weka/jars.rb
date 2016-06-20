require 'active_support/concern'

module Weka
  module Jars
    extend ActiveSupport::Concern

    included do
      require 'lock_jar'

      lib_path = File.expand_path('../../', File.dirname(__FILE__))
      lockfile = File.join(lib_path, 'Jarfile.lock')
      jars_dir = File.join(lib_path, 'jars')

      LockJar.install(lockfile, local_repo: jars_dir)
      LockJar.load(lockfile, local_repo: jars_dir)
    end
  end
end
