require 'rest-client'
require 'json'

host = "localhost:3000"
client_id = '93f6859241168f6fcd70fdf2dfd576fb1aa4676ad90df420b5b2071cee999b8d'
client_secret = '2687142d91685b4890bb7e423bffe0b06672d04349c2a90999b2b5b6b8330522'

# response = RestClient.post "http://#{host}/oauth/token", {
#   grant_type: 'client_credentials',
#   client_id: client_id,
#   client_secret: client_secret
# }

# puts JSON.parse(response)
# app_token = JSON.parse(response)["access_token"]
app_token = '3daa374e75ada16b028d2485408934bf5450d3de4ec2128b607bd88d7a6044b3'

# response = RestClient.post "http://#{host}/oauth/token", {
#   grant_type: 'password',
#   client_id: client_id,
#   email: 'admin@mail.com',
#   password: '123456'
# }

# puts JSON.parse(response)
# user_token = JSON.parse(response)["access_token"]
user_token = '16ad6470173dc4018cb8245c0ba8312e885df5c3c639e284b2bfe50c2ee51a95'

users = RestClient.get "http://#{host}/api/v1/users", {'Authorization' => "Bearer #{user_token}"}

puts JSON.parse(users)