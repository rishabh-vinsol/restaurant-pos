class RandomTokenGenerator
  def initialize(model_name, model_token)
    @model_name = model_name.constantize
    @model_token = model_token
  end

  def generate_token
    loop do
      @token = SecureRandom.base64
      break unless @model_name.exists?("#{@model_token}": @token)
    end
    @token
  end
end
