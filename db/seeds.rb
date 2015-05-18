# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

alyssa = Person.create(name: 'Allysa Roberts', email: "alyssa@me.com")
matt = Person.create(name: 'Matt Johnson', email: "matt@mattjohnson.com")
alex = Person.create(name: 'Alex Todd', email: "alextodd@gmail.com")
david = Person.create(name: 'David Chouinard', :street_line1 => "1 Test St.", :city => "Beverly Hills", :state => "CA", :postal_code => "90210", :country => "US")
darrell = Person.create(name: 'Darrell Lewis')
darrell2 = Person.create(name: 'Darrell Jones')

Introduction.create(from_node: alyssa, to_node: matt, content: "Matt is one of the most thoughtful and genuine people I know.", thumbnail: "http://assets.lob.com/obj_d6780f4709509205_thumb_small_1.png", image: "http://assets.lob.com/obj_d6780f4709509205_thumb_large_1.png", expected_delivery: Date.today)
Introduction.create(from_node: matt, to_node: alex, content: "Alex is passionate and fearless: he inspires me to be ambitious.", thumbnail: "http://assets.lob.com/obj_d6780f4709509205_thumb_small_1.png", image: "http://assets.lob.com/obj_d6780f4709509205_thumb_large_1.png", expected_delivery: Date.today)
Introduction.create(from_node: alex, to_node: david, content: "David is one of the most brilliant and creative people I've met.", thumbnail: "http://assets.lob.com/obj_d6780f4709509205_thumb_small_1.png", image: "http://assets.lob.com/obj_d6780f4709509205_thumb_large_1.png", expected_delivery: Date.today)

Introduction.create(from_node: alex, to_node: darrell, content: "Darrell is one of the most brilliant and creative people I've met.", thumbnail: "http://assets.lob.com/obj_d6780f4709509205_thumb_small_1.png", image: "http://assets.lob.com/obj_d6780f4709509205_thumb_large_1.png", expected_delivery: Date.today)
introduction.create(from_node: alex, to_node: darrell2, content: "darrell is one of the most brilliant and creative people i've met.", thumbnail: "http://assets.lob.com/obj_d6780f4709509205_thumb_small_1.png", image: "http://assets.lob.com/obj_d6780f4709509205_thumb_large_1.png", expected_delivery: Date.today)
