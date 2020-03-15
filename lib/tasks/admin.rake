# ShinyCMS admin user administration tasks

require 'dotenv/tasks'

# rails shiny:admin:create - creates a new superadmin user, with full privs
# You can pass in details on the command line:
# rails shiny:admin:create username=admin password=nope email=you@example.com
# Otherwise, it picks them up from your .env/ENV, or prompts for them

namespace :shiny do
  namespace :admin do
    desc 'ShinyCMS: create a new super-admin user (all capabilities enabled)'
    # :nocov:
    task create: %i[ environment dotenv ] do
      username = ENV['username'] || ENV['SHINYCMS_ADMIN_USERNAME']
      password = ENV['password'] || ENV['SHINYCMS_ADMIN_PASSWORD']
      email    = ENV['email'   ] || ENV['SHINYCMS_ADMIN_EMAIL'   ]

      admin = User.new( username: username, password: password, email: email )
      admin.valid?

      while admin.errors.messages.keys.include? :username
        admin.errors[:username].each do |error|
          puts "Username #{error}" unless username.nil?
        end
        puts 'Please specify a username for your new admin account:'
        username = STDIN.gets.strip

        admin = User.new( username: username, password: password, email: email )
        admin.valid?
      end

      while admin.errors.messages.keys.include? :password
        admin.errors[:password].each do |error|
          puts "Password #{error}" unless password.nil?
        end
        puts 'Please specify a password for your new admin account:'
        password = STDIN.gets.strip

        admin = User.new( username: username, password: password, email: email )
        admin.valid?
      end

      while admin.errors.messages.keys.include? :email
        admin.errors[:email].each do |error|
          puts "Email #{error}" unless email.nil?
        end
        puts 'Please specify the email address of your new admin account:'
        email = STDIN.gets.strip

        admin = User.new( username: username, password: password, email: email )
        admin.valid?
      end

      admin.skip_confirmation!
      admin.save!

      Capability.all.each do |capability|
        admin.user_capabilities.find_or_create_by! capability_id: capability.id
      end

      puts "ShinyCMS admin user '#{username}' created! You can log in now."
    end
    # :nocov:
  end
end
