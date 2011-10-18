Factory.define :user do |user|
  user.name                  "Mitch Cumstein"  
  user.email                 "mitch@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end  

Factory.sequence :email do |n|
  "person-#{n}@example.org"
end

Factory.define :bloc do |bloc|
  bloc.content "Foo bar" 
  bloc.association :user
end  