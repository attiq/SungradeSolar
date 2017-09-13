# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


puts 'Deleting existing roles...'
roles = Role.all
roles.each { |role| role.destroy } if roles.present?

puts 'Creating roles...'
%w(admin customer staff).each do |name|
  Role.create!(name: name)
end

puts 'Deleting existing users...'
users = User.all
users.each { |u| u.destroy } if users.present?

puts 'Creating admin ....'
admin = User.new(email: 'admin@sungrade.com',
                   password: '12345678',
                   password_confirmation: '12345678')
admin.roles << Role.find_by_name('admin')
admin.save!
