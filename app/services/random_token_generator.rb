class RandomTokenGenerator
  def initialize(model_name, token_name)
    @model_name = model_name.constantize
    @token_name = token_name
  end

  def generate_token
    loop do
      @token = SecureRandom.base64
      break unless @model_name.exists?("#{@token_name}": @token)
    end
    @token
  end
end
