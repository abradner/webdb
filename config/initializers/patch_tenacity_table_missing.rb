#https://github.com/jwood/tenacity/issues/31

##FIXED

#Tenacity::OrmExt::ActiveRecord::ClassMethods.class_eval do
#  def _t_id_type
#    @_t_id_type_clazz ||= begin
#      Kernel.const_get(columns.find { |x| x.primary }.type.to_s.capitalize)
#    rescue
#      Integer
#    end
#  end
#end
