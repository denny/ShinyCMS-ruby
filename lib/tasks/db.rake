# Make rake db:seed a bit cleverer - allow reloading/refreshing of seed data
# https://gist.github.com/koffeinfrei/04bbe38f16ff9d49bebd

namespace :db do
  task seed: :seed_helper

  task seed_helper: :environment do
    def seed( model, find_or_create_by, update_with = {} )
      record = model.where( find_or_create_by ).first_or_initialize

      if record.update( update_with )
        record
      else
        raise RuntimeError "Couldn't save #{record.class} " \
              "(#{record.errors.full_messages.join(', ')})"
      end
    end
  end
end
