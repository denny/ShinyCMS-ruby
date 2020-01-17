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
    username  ||= 'admin'
    password  ||= 'I should change this password before I do anything else!'
    email     ||= 'admin@example.com'

    admin = User.create!( username: username, email: email, password: password )

    admin.confirm

    Capability.all.each do |capability|
      admin.user_capabilities.find_or_create_by( capability_id: capability.id )
    end
  end
end
