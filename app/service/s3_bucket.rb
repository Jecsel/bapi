require 'aws-sdk-s3'
class S3Bucket
    def initialize
		@s3 = Aws::S3::Resource.new
	end
	
	def upload data,filename
		obj = @s3.bucket( ENV["S3_PAYMENT_DOC_STORAGE"] ).object("POST_PAYMENT_PAYLOAD/#{filename}")
		obj.put body:data
	end
end