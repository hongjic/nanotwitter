module JSONRecord

  def to_json_obj fields = nil
    obj = {}
    default = self.class.default
    fields ||= default
    fields.each do |key|
      obj.store(key, instance_eval("self.#{key}")) if default.include? key
    end
    obj
  end

end