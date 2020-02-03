# User administration tasks
namespace :admin do
  desc 'Create a super-admin user, with the full set of capabilities'
  task :create, %i[ username password email ] => [ :environment ] do |_t, args|
    username    = args[ :username ]
    password    = args[ :password ]
    email       = args[ :email    ]
    username  ||= ENV[ 'SHINYCMS_ADMIN_USERNAME' ]
    password  ||= ENV[ 'SHINYCMS_ADMIN_PASSWORD' ]
    email     ||= ENV[ 'SHINYCMS_ADMIN_EMAIL'    ]

    admin = User.new( username: username, password: password, email: email)
    admin.valid?

    while admin.errors.messages.keys.include? :username
      puts 'Please specify a username for your ShinyCMS super-admin user:'
      username = STDIN.gets.strip

      admin = User.new( username: username, password: password, email: email)
      admin.valid?
    end

    while admin.errors.messages.keys.include? :password
      puts 'Please specify a password for your ShinyCMS super-admin user:'
      password = STDIN.gets.strip

      admin = User.new( username: username, password: password, email: email)
      admin.valid?
    end

    while admin.errors.messages.keys.include? :email
      puts 'Please specify the email address of your ShinyCMS super-admin user:'
      email = STDIN.gets.strip

      admin = User.new( username: username, password: password, email: email)
      admin.valid?
    end

    admin.save!
    admin.confirm

    Capability.all.each do |capability|
      admin.user_capabilities.find_or_create_by!( capability_id: capability.id )
    end

    puts "ShinyCMS super-admin user '#{username}' created! You can log in now."
  end
end
