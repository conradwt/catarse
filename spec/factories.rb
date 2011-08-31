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
    name          { FactoryGirl.generate(:name) }
    title         { FactoryGirl.generate(:name) }
    path          { FactoryGirl.generate(:name) }
    host          { FactoryGirl.generate(:name) }
    gender        "male"
    email         { FactoryGirl.generate(:email) }
    twitter       "foobar"
    facebook      "http://www.facebook.com/FooBar"
    blog          "http://blog.foo.bar"
  end

  factory :user do |f|
    provider      "twitter"
    uid           { FactoryGirl.generate(:uid) }
    name          "Foo bar"
    email         { FactoryGirl.generate(:email) }
    bio           "This is Foo bar's biography."
    site
  end

  factory :category do
    name          { FactoryGirl.generate(:name) }
  end

  factory :project do
    name          "Foo bar"
    site
    user
    category
    about         "Foo bar"
    headline      "Foo bar"
    goal          10000
    expires_at    { 1.month.from_now }
    video_url     'http://vimeo.com/17298435'
  end

  factory :reward do
    project
    minimum_value 1.00
    description   "Foo bar"
  end

  factory :backer do
    project
    user
    site
    confirmed     true
    value         10.00
  end

  factory :oauth_provider do
    name          'GitHub'
    strategy      'GitHub'
    path          'github'
    key           'test_key'
    secret        'test_secret'
  end

  factory :configuration do
    name 'Foo'
    value 'Bar'
  end

end
