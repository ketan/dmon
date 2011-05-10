# Copyright (c) 2011 Ketan Padegaonkar.
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module Dmon
  
  # An abstraction for a ruby process.
  # 
  # Typical usage is:
  # 
  #     Process.new do |p|
  #       p.description = 'foo'
  #       # all fields accept procs or strings
  #       p.start_script    = 'bin/start.sh'
  #       p.start_script    = proc { running? ? 'bin/start.sh' : 'bin/restart.sh' }
  #       p.stop_script     = 'bin/stop.sh'
  #       p.status_script   = 'bin/status.sh'
  #     end
  class Process
    include ProcOrObject
    
    # The description of the process
    proc_or_object :description
    
    # A proc or string describing how the process should start
    proc_or_object :start_script
    
    # A proc or string describing how a process should be stopped
    proc_or_object :stop_script
    
    # A proc or string describing how a process can return its status
    proc_or_object :status_script
    
    # Defines a new process and yields itself
    def initialize(&block)
      yield self if block_given?
    end
  end

end
