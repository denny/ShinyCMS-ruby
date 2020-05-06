# frozen_string_literal: true

# ShinyCMS tasks for setting up a demo site

require 'dotenv/tasks'

# rails shiny:demo:load
# - resets the database
# - creates a super-admin
# - inserts the demo site data
#
# rails shiny:demo:dump
# - dumps the current database contents to db/demo-data.rb

namespace :shiny do
  namespace :demo do
    desc 'ShinyCMS: reset database, create admin user, and load demo site data'
    # :nocov:
    prereqs = %i[
      environment dotenv confirm db:reset shiny:admin:get_admin_details
    ]
    task load: prereqs do
      @shiny_admin.skip_confirmation!
      @shiny_admin.save!
      @shiny_admin.grant_all_capabilities

      File.open( Rails.root.join( 'db/demo-data.rb' ), 'r' ) do |dump|
        data = dump.read
        # TODO: Yes, yes, I know.
        # Had to munge the next line to get it into git, trollolol
        val_with_an_E_in_front data
      end

      FeatureFlag.enable :user_login

      puts 'Demo data loaded and admin account created.'
      puts "You can log in as '#{@shiny_admin.username}' now."
    end

    task confirm: %i[ environment dotenv ] do
      msg = 'Loading the demo site data wipes the database. Are you sure? (y/N)'
      STDOUT.puts msg
      unless STDIN.gets.chomp.downcase.in? %w[ y yes ]
        puts 'Thank you. No action taken, database is unchanged.'
        exit
      end
    end

    task dump: %i[ environment dotenv ] do
      # rubocop:disable Layout/MultilineArrayLineBreaks
      models = %w[
        EmailRecipient MailingList Subscription
        Blog BlogPost NewsPost Discussion Comment InsertElement
        PageTemplate PageTemplateElement PageSection Page PageElement
      ]
      # rubocop:enable Layout/MultilineArrayLineBreaks

      big_dump = ''
      models.each do |model|
        puts "Dumping: #{model}"
        dump = SeedDump.dump(
          model.constantize, exclude: %i[created_at updated_at]
        )
        next unless dump # no data to dump

        big_dump = "#{big_dump}\n#{dump}"
      end
      result = big_dump.gsub 'user_id: 1', 'user_id: @shiny_admin.id'

      File.open( Rails.root.join( 'db/demo-data.rb' ), 'w' ) do |dump|
        dump.write result
      end
    end
    # :nocov:
  end
end
