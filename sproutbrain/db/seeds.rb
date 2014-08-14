# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Seed.create(name: 'Leeks', min_duration: 7, max_duration: 15, family: 'Allium', nutrition: "Vitamin A, B, C, E, Calcium, Iron, Protein 20%", tips: "Freezing seeds extends their lifetime")
Seed.create(name: 'Radish', min_duration: 3, max_duration: 6, family: 'Brassicas', nutrition: "Vitamins A, B, C, E, K, Anti-Oxidants, Calcium, Iron, Protein 35%", tips: "")
Seed.create(name: 'Popcorn', min_duration: 1, max_duration: 3, family: 'Grains', nutrition: "Vitamins A, B, C, E, K, Calcium, Iron, Potassium, Protein 30%", tips: "Can be used in breads")
Seed.create(name: 'Flax', min_duration: 5, max_duration: 6, family: 'Leafy Sprout Seeds', nutrition: "Vitamins A, B, C, E, K, Calcium, Iron, Potassium, Protein 35%", tips: "")
Seed.create(name: 'Pumpkin Seed', min_duration: 1, max_duration: 3, family: 'Nuts/Seeds', nutrition: "Vitamins A, B, C, E, Calcium, Iron, Potassium, Protein 20-30%", tips: "Try roasting sprouted seeds in the oven")
Seed.create(name: 'Yellow Peas', min_duration: 2, max_duration: 5, family: 'Pulses', nutrition: "Vitamins A, B, C, E, Calcium, Iron, Potassium, Protein 20-30%", tips: "Toxin precautions: http://www.kitchengarden.co.za/pulses/")
Seed.create(name: 'Poppy Seed', min_duration: 3, max_duration: 6, family: 'Spices', nutrition: "Vitamins A, B, C, E, K, Calcium, Iron, Potassium, Protein 20-35%", tips: "")
