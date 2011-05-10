# Copyright (c) 2011 Ketan Padegaonkar.
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module Dmon

  # Use in place of +attr_accessor+ that can use return values of procs
  #   class Person
  #     include Dmon::ProcOrObject
  #     proc_or_object  :name
  #   end
  # 
  #   p = Person.new
  #   p.name = { 'joe' }
  #   p.name
  #   => joe
  module ProcOrObject
    
    module ClassMethods #nodoc:
      # 
      def proc_or_object(*names)
        names.each do |name|
          class_eval(<<-EOS, __FILE__, __LINE__)
            @@__#{name} = nil
            def #{name}
              @@__#{name}.respond_to?(:call) ? @@__#{name}.call : @@__#{name}
            end
            
            def #{name}=(value_or_proc)
              @@__#{name} = value_or_proc
            end
          EOS
        end
      end
    end
    
    
    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end
end