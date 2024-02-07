module History
  def attr_accessor_with_history(attr)
    attr = attr.to_s
    attr_reader attr

    class_eval "
      def #{attr}_history
        @#{attr}_history || nil
      end
      def #{attr}
        @#{attr}
      end

      def #{attr}=(new_value)
        @#{attr}_history ||= []
        @#{attr}_history << @#{attr} = new_value
      end

      ", __FILE__, __LINE__ - 13
  end
end
