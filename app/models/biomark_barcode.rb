class BiomarkBarcode < ApplicationRecord
 
    connects_to database: { writing: :biomark_db, reading: :biomark_db }
end