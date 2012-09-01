ActionController::Dispatcher.middleware.use OmniAuth::Builder do
  provider :facebook, FB_APP_ID, FB_APP_KEY, {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
end
