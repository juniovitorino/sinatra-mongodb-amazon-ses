#encoding: utf-8

class Application < Sinatra::Application

  Mongoid.load! File.dirname(__FILE__) + '/db/mongodb.yml'

  set :haml, { format: :xhtml }
  set :ses, AWS::SES::Base.new(:access_key_id => ENV['ACCESS_KEY_ID'], :secret_access_key => ENV['SECRET_ACCESS_KEY'])
  
  configure :production do
    APP_URL  = "https://www.yourproductionappurl.com"
    use Rack::Rewrite do
      r301 %r{.*}, "#{APP_URL}$&", :if => Proc.new {|rack_env|
        rack_env['SERVER_NAME'] != "#{APP_URL}" && ENV['RACK_ENV'] == "production"
      }
    end
  end

  configure :development do
    use BetterErrors::Middleware
    BetterErrors.application_root = File.expand_path("..", __FILE__)
    APP_URL  = "http://127.0.0.1:9393"
  end
  
  get '/' do
    haml :index
  end
  
  # try: curl -d "name=YOUR_NAME&email=YOUR_EMAIL&subject=YOUR_SUBJECT&message=YOUR_MESSAGE" http://127.0.0.1:9393/send
  post '/send' do
    @flash = {}
    @message             = Message.new
    @message.name        = Sanitize.clean params[:name]
    @message.email       = Sanitize.clean params[:email]
    @message.message     = Sanitize.clean params[:message]
    @message.subject     = Sanitize.clean params[:subject]

    if Validators::Email.valid(@message.email)
      body         = haml :message
      subject      = @message.subject
      to           = ENV['RECEIVER_EMAIL']
      header_name  = @message.name.force_encoding('ISO-8859-1').encode('UTF-8')
      from         = "=?utf-8?q?#{header_name}?= <#{ENV['YOUR_AWS_VALID_SENDER_EMAIL']}>"
      reply        = "#{header_name} <#{@message.email}>"
      
      begin
        settings.ses.send_email :to => to,
          :from      => from,
          :reply_to  => reply,
          :subject   => subject,
          :html_body => body
        
          @flash[:success] = "Message sent and stored successfully." if @message.save
      rescue Exception => e
        @flash[:error] = e
      end
    else
      @flash[:error] = "Invalid email provided. Please type a valid email."
    end
    haml :response
  end
end