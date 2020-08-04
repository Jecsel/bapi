namespace :campaign do
    desc "TODO"
    task in_charge: :environment do
    ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0")
    ActiveRecord::Base.connection.execute("TRUNCATE in_charge_people")
    ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1")
    _in_charge_people = [
          {name:"Ana Ling"},
          {name:"Anylia Johnny"},
          {name:"Charanjit Kaur"},
          {name:"Cherlyn"},
          {name:"Chin Chen Tieng"},
          {name:"Coral"},
          {name:"Daya"},
          {name:"Eeswary"},
          {name:"Esusa"},
          {name:"Eunice Lee"},
          {name:"Ganeson"},
          {name:"Haley Wong"},
          {name:"Hamat"},
          {name:"Jamil"},
          {name:"Lee Kean"},
          {name:"Mariam"},
          {name:"Mohd Annuar Bin Nordin"},
          {name:"Ng Wai Kit"},
          {name:"Praveen"},
          {name:"Puganeswari"},
          {name:"Raymond"},
          {name:"Sachin"},
          {name:"Salina"},
          {name:"Sheela"},
          {name:"Siew Hie"},
          {name:"Simson Pragasam"},
          {name:"Siti Marha"},
          {name:"Sni"},
          {name:"Tevitha Naidu"},
          {name:"Toh Hee"},
          {name:"Tracy"},
          {name:"Vickneswaran"},
          {name:"WaiPin"}
      ]
    InChargePerson.create _in_charge_people
    p "Created in charge people"
    end
end