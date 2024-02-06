# Подсчет количества ссылок
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
  end

  # добавляем атрибут instances в класс
  module ClassMethods
    def instances
      @instances ||= 0
    end

    def instances=(count)
      @instances_count = count
    end
  end

  private

  def register_instance
    self.class.instances += 1
  end
end
