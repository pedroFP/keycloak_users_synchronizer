module ModelSerializer
  include ActiveModel::Serialization
 
  def attributes
    instance_variables.each_with_object({}) do |var, hash|
      hash[var.to_s.delete('@')] = instance_variable_get(var)
    end
  end
end