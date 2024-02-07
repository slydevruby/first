
# Добавление валидации
module Validation
  def self.included(base)
    base.extend ClassMethods
  end

  def validate!
    self.class.validate!(self)
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  module ClassMethods
    def validate(name, options = {})
      @list ||= []
      @list << [name, options]
    end

    def validate!(inst)
      ins_vars = inst.instance_variables
      @list.each do |option|
        xvar = "@#{option[0]}"

        raise "#{option[0]}: Error: value does not exists" if option[1][:presence] && !(ins_vars.include? xvar.to_sym)

        ins_vars.each do |var|
          next unless var.to_s == xvar

          if option[1][:presence]
            raise "#{option[0]}: Error: value is nil" if inst.instance_variable_get(var).nil?

            if inst.instance_variable_get(var).is_a?(String) && inst.instance_variable_get(var).empty?
              raise "#{option[0]}: Error: value is empty"
            end
          end
          if option[1][:type] && !(inst.instance_variable_get(var).is_a? option[1][:type])
            raise "#{option[0]}: Error: invalid type"
          end
          if option[1][:length] && (inst.instance_variable_get(var).size != option[1][:length])
            raise "#{option[0]}: Error: invalid length"
          end
          if option[1][:format] && (inst.instance_variable_get(var) !~ option[1][:format])
            raise "#{option[0]}: Error: invalid format"
          end
        end
      end
      true
    end
  end
end
