FactoryGirl.define do

  sequence :name do |n|
    "Foo bar #{n}"
  end

  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :uid do |n|
    "#{n}"
  end

  factory :site do |f|
    name { Factory.next(:name) }
    title { Factory.next(:name) }
    path { Factory.next(:name) }
    host { Factory.next(:name) }
    gender "male"
    email { Factory.next(:email) }
    twitter "foobar"
    facebook "http://www.facebook.com/FooBar"
    blog "http://blog.foo.bar"
  end

  factory :user do |f|
    provider "twitter"
    uid { Factory.next(:uid) }
    name "Foo bar"
    email { Factory.next(:email) }
    bio "This is Foo bar's biography."
    association :site
  end

  factory :category do
    name { Factory.next(:name) }
  end

  factory :project do
    name "Foo bar"
    association  :site
    assocication :user
    association  :category
    about        "Foo bar"
    headline     "Foo bar"
    goal         10000
    expires_at { 1.month.from_now }
    video_url 'http://vimeo.com/17298435'
  end

  factory :reward do
    association   :project
    minimum_value 1.00
    description   "Foo bar"
  end

  factory :backer do
    association :project
    association :user
    association :site
    confirmed true
    value 10.00
  end

  factory :oauth_provider do
    name 'GitHub'
    strategy 'GitHub'
    path 'github'
    key 'test_key'
    secret 'test_secret'
  end

  factory :configuration do
    name 'Foo'
    value 'Bar'
  end

end
