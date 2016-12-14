class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_session_headers
  before_action :set_default_response_format

  def project_name
    Myapp::Application::PROJECT_NAME
  end

  def admin_token
    Myapp::Application::ADMIN_TOKEN
  end

  def set_session_headers
    if Rails.env.development?
      @data_url =  "https://data.#{project_name}.hasura-app.io/v1/query/"
      @headers  = { 'Authorization' => 'Bearer ' + admin_token }
    else
      @data_url = 'http://data.hasura/v1/query/'
      @headers  = { 'X-Hasura-Role' => 'admin', 'X-Hasura-User_Id' => '1' }
    end
  end

  def hello
    url = @data_url
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'}.merge(@headers) )
    query = {
          'type' => 'select',
          'args' => {
              'table' => { 'schema' => 'hdb_catalog', 'name' => 'hdb_table' },
              'columns' => ['*.*'],
              'where' => {'table_schema': 'public'}
          }
    }
    req.body = query.to_json
    response = http.request(req)

    render json: response.body, status: response.code
  end

  def get_role
    role = params[:role]
    roles = request.headers['X-Hasura-Allowed-Roles']

    if role.in? (roles)
      render json: "Hey you have the #{role} role"
    else
      render json: "DENIED: Only a user with #{role} role can access this endpoint", status: 403
    end
  end


private

  def set_default_response_format
    request.format = :json
  end  

end
