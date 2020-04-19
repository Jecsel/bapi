namespace :location do
  desc "TODO"
  task create: :environment do
    _locations = [
        {
            name:"Columbia Asia Hospital Klang",
            address:"Jalan Mahkota 1 / KU 2, Mutiara Bukit Raja 2, KM2 off Jalan Meru, Batu Dua Belas, 41050 Klang, Selangor, Malaysia"
        },
        {
            name:"Timberland Medical Centre",
            address:"5164-5165, Block 16 KLCD 2 1/2 Mile, Rock Road, Taman Timberland, 93250 Kuching, Sarawak, Malaysia"
        },
        {
            name:"Bukit Mertajam",
            address:"Ground Floor, G-07, Medan Perniagaan Pauh Jaya, Jalan Baru, 13700 Seberang Perai, Penang"
        }
    ]
    Location.create _locations
  end

end
