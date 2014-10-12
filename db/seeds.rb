# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Agency.delete_all
Package.delete_all


10.times do |i|
  Agency.create(location: "Location ##{i}")
end

3.times do |i|
	User.create(username: "user#{i}", role: i, email: "user#{i}@a.com", password: "12345678", agency_id: Agency.first.id)
end

5.times do |i|
	Package.create(
		:description => "package#{i}",
		:weight => rand(1.0..100.0),
		:height => rand(1.0..100.0),
		:width => rand(1.0..100.0),
		:depth => rand(1.0..100.0),
		:value => rand(1.0..100.0),
		:sender_id => User.first.id,
		:receiver_id => User.last.id,
		:agency_id => Agency.offset(rand(Agency.count)).first.id,
		:shipping_cost => rand(1.0..100.0),
		:ref_number => "MC-"+SecureRandom.hex(10).to_s
	  )
end