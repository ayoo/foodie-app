if User.all.empty?
  User.create!(email: "admin@foodieapp.com", password: "demo0nly", first_name: "Foo", last_name:"Bar", is_admin: true)
end