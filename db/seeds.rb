# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# db/seeds.rb
require 'faker'

puts "Seeding database..."

# --- Clear existing data ---
BandFlyer.destroy_all
Flyer.destroy_all
Band.destroy_all
Venue.destroy_all

# --- VENUES ---
venue_names = [
  "The Observatory",
  "Main Street Hall",
  "Riverside Club",
  "The Underground",
  "Grand Central Hall",
  "The Loft",
  "City Lights Venue",
  "Eastside Hall",
  "Northgate Club",
  "Harbor Hall",
  "Gilman Street Project",
  "ABC No Rio"
]

venues = venue_names.map do |name|
  Venue.create!(
    name: name,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    country: "USA"
  )
end

puts "Created #{venues.size} venues"

# --- BANDS ---
bands = []
30.times do
  bands << Band.create!(
    name: Faker::Music.band,
    website: Faker::Internet.url(host: 'bandwebsite.com'),
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    country: "USA"
  )
end

puts "Created #{bands.size} bands"

# --- FLYERS ---
# Get image files from directory
images_dir = Rails.root.join("lib", "assets", "flyer_images")
image_files = Dir.glob(images_dir.join("*.{jpg,jpeg,png,gif,webp}"))

if image_files.empty?
  puts "⚠️  Warning: No images found in #{images_dir}"
  puts "   Flyers will be created without images."
  puts "   Add image files to that directory and re-seed to attach images."
  puts ""
else
  puts "📁 Found #{image_files.count} image(s) for random assignment"
end

50.times do
  venue = venues.sample
  flyer_date = Faker::Date.between(from: 6.months.ago, to: 3.months.from_now)

  flyer = Flyer.new(
    title: "#{Faker::Music.band} Live at #{venue.name}",
    event_date: flyer_date,
    venue: venue,
    notes: Faker::Lorem.sentence(word_count: 12)
  )

  # Attach a random image if available (before validation)
  if image_files.any?
    random_image_path = image_files.sample
    flyer.image.attach(
      io: File.open(random_image_path),
      filename: File.basename(random_image_path),
      content_type: Marcel::MimeType.for(Pathname.new(random_image_path))
    )
  end

  # Save the flyer (will trigger validation)
  flyer.save!

  # Assign 2–5 random bands
  flyer_bands = bands.sample(rand(2..5))
  flyer.bands << flyer_bands

  if image_files.any?
    puts "Created flyer: #{flyer.title} with #{flyer_bands.size} bands and image: #{File.basename(flyer.image.filename.to_s)}"
  else
    puts "Created flyer: #{flyer.title} with #{flyer_bands.size} bands"
  end
end

puts "Seeding completed!"
