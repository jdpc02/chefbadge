nginx_server 'www.example.com'

nginx_server 'notes' do
  host 'notes.example.com'
  static_path '/var/www/notes/'
  landing_page_content '<h1>Come back to this again</h1>'
end

nginx_server 'blog' do
  action :delete
end

nginx_server 'status_site' do
  host 'status.example.com'
  static_path '/var/www/status'
  action :delete
end
