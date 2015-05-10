# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

alyssa = Person.create(name: 'Allysa Roberts', email: "alyssa@me.com")
matt = Person.create(name: 'Matt Johnson', email: "matt@mattjohnson.com")
alex = Person.create(name: 'Alex Todd', email: "alextodd@gmail.com")
david = Person.create(name: 'David Chouinard')
darrell = Person.create(name: 'Darrell Lewis')


Introduction.create(from_node: alyssa, to_node: matt, content: "Matt is one of the most thoughtful and genuine people I know.")
Introduction.create(from_node: matt, to_node: alex, content: "Alex is passionate and fearless: he inspires me to be ambitious.")
Introduction.create(from_node: alex, to_node: darrell, content: "Darrell is one of the most brilliant and creative people I've met.")
Introduction.create(from_node: alex, to_node: david, content: "David is one of the most brilliant and creative people I've met.")

#alyssa.introduced << alex
#alex.introduced << david
#alex.introduced << darrell
