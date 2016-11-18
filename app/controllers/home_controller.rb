class HomeController < ApplicationController
  def hello
    puts "cualquier #{current_user.email}"
  end
end
