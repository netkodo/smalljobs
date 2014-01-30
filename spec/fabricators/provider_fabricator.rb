Fabricator(:provider) do
  transient confirmed: true

  username  { sequence(:username) { |i| "user#{ i }" }}
  password  { Forgery(:basic).password.rjust(10, 'a') }

  firstname { Forgery(:name).first_name }
  lastname  { Forgery(:name).last_name }

  street { "#{ Forgery(:address).street_name } #{ Forgery(:address).street_number }" }
  place

  email  { sequence(:email)  { |i| "provider#{ i }@example.com" }}
  phone  { sequence(:phone)  { |i| "0041 056 111 22 3#{ i }" }}
  mobile { sequence(:mobile) { |i| "0041 079 111 22 3#{ i }" }}

  contact_preference  { 'mobile' }
  contact_availability { 'all day' }

  active { true }

  after_create do |user, transients|
    user.confirm! if transients[:confirmed]
  end
end

Fabricator(:provider_with_region, from: :provider) do
  after_create do |user|
    Fabricate(:region, places: [user.place])
  end
end
