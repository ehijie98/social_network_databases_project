require_relative 'lib/database_connection'
require './lib/post_repository'
require './lib/user_account_repository'

DatabaseConnection.connect('social_network')

repo = PostRepository.new

repo.all.each do |post|
    p post

end


