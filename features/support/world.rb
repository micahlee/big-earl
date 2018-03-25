module EarlWorld

  def last_short_url
    @result["short_url"]
  end
  
  def last_json
    @result.to_json
  end

  # Adapted from: https://github.com/cyberark/conjur/blob/f1f812b1c6c703cf53e35a787916792da237b023/cucumber/api/features/support/world.rb
  def headers
      @headers ||= {}
    end
  
  def post_json path, body, options = {}
      result = rest_resource(options)[path].post(body)
      set_result result
  end

  def get_json path, options = {}
    result = rest_resource(options)[path].get
    set_result result
  end

  def set_result result
    @status = result.code
    @response = result
    if result.headers[:content_type] =~ /^application\/json/
      @result = JSON.parse(result)
      if @result.respond_to?(:sort!)
        @result.sort! unless @result.first.is_a?(Hash)
      end
    else
      @result = result
    end
  end

  def try_request can
      begin
        yield
      rescue RestClient::Exception
        @exception = $!
        @status = $!.http_code
        if can
          raise
        else
          set_result @exception.response
        end
      end
  end

  def rest_resource options
      args = [ ENV['BIG_EARL_URL'] ]
      args << Hash.new if args.length == 1
      args.last[:max_redirects] = 0
      args.last[:headers] ||= {}
      args.last[:headers].merge(headers) if headers
      RestClient::Resource.new(*args).tap do |request|
        headers.each do |k,v|
          request.headers[k] = v
        end
      end
  end

end

World(EarlWorld)