class Generator
    def initialize
        self
    end
    def generate_numeric
        (0..9).to_a.sample(4).join()
    end
    def generate_reference_code
        return "DRIVE-#{('A'..'Z').to_a.sample(6).join()}"
    end
    def generate_alpha_numeric 
        a = ('A'..'Z').to_a.sample(10) 
        b = (0..9).to_a.sample(10)
        c = a + b
        c.sample(20).join()
    end
end
