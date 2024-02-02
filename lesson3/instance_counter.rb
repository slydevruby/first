module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def instances
      @instances_count ||= 0
    end    

    def instances= (n)
      @instances_count = n
    end
  end

  private
  def register_instance
    self.class.instances += 1
  end
end
