require 'io/console'

namespace :admin do
  desc 'Creates new admin user'
  task :new => :environment do
    user_params = {}
    puts 'Enter the following details to make a new admin'
    print 'First Name : ' 
    user_params[:first_name] = STDIN.gets.chomp
    print 'Last Name : '
    user_params[:last_name] = STDIN.gets.chomp
    print 'Email : '
    user_params[:email] = STDIN.gets.chomp
    print 'Password : '
    user_params[:password] = STDIN.noecho(&:gets).chomp
    puts
    print 'Confirm Password : '
    user_params[:password_confirmation] =  STDIN.noecho(&:gets).chomp
    puts
    user_params[:verified_at] = Time.now
    user_params[:role] = 'admin'

    admin = User.new(user_params)
    if admin.save
      puts 'Admin user created successfully.'
    else
      puts 'Error creating admin user.'
      puts "Following #{ActionController::Base.helpers.pluralize(admin.errors.count, "error")} prohibited this admin from being saved: "
      puts admin.errors.to_a
    end
  end
end
