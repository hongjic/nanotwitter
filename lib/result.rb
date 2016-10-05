module Api
  class Result

    attr_accessor :status
    attr_accessor :msg

    def initialize status, msg
      @status = status
      @msg = msg
    end

    def to_json 
      resultCode = @status ? "success" : "error"
      {resultCode: resultCode, resultMsg: msg}.to_json
    end
  end

end