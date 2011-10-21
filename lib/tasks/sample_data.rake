require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Chris Klein",
                         :email => "chrisklein@nomabi.com",
                         :password => "foobar",
                         :password_confirmation => "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@nomabi.org"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
    
    10.times do
      User.all(:limit=> 6).each do |user|
        @bloc = user.blocs.create!(:content => "bloc")
        user.blocposts.create!(:content => Faker::Lorem.sentence(5), :bloc_id => @bloc.id)
        user.blocposts.create!(:content => Faker::Lorem.sentence(5), :bloc_id => @bloc.id)
      end  
    end
      
  end
end