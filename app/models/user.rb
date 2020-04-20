class User < ApplicationRecord
    before_create :encrypt_password

    def valid_password? password
        self.password === Digest::MD5.hexdigest(password)[0..19]
    end
    
    private

    def encrypt_password
        self.password = Digest::MD5.hexdigest(self.password)[0..19]
    end
    
end
