# Создание двух аксессоров: первый с историей,
# второй с проверкой типа при присваивании
module Accessors
  def attr_accessor_with_history(attr)
    attr = attr.to_s
    attr_reader attr

    class_eval "
      def #{attr}_history
        @#{attr}_history || nil
      end

      def #{attr}=(new_value)
        @#{attr}_history ||= []
        @#{attr} = new_value
        @#{attr}_history << new_value
      end
      ", __FILE__, __LINE__ - 10
  end

  def strong_accessor(attr, cls)
    attr = attr.to_s
    attr_reader attr

    class_eval %{
      def #{attr}=(new_value)
        if new_value.is_a? #{cls}
          @#{attr} = new_value
        else
          raise "Invalid type, must be #{cls}"
        end
      end
      }, __FILE__, __LINE__ - 8
  end
end
