class Slack
    attr_accessor :_url, :_payload
    
    def initialize
        @_url ="https://slack.com/api/chat.postMessage"
        @_payload = {
            token:'xoxp-198833213056-323448602978-693979208484-c7e39c66216c848c53b9fdfcd1a603e9',
            blocks:[]
        }
    end
    
    #set channel
    def channel(_channel)
        @_payload[:channel] = _channel
        self
    end
    
    #single content 
    def section content
        
        _payload[:blocks] << {
            type:"section",
            text:{
                type:"mrkdwn",
                text:content
            }
        }
        self
    end
    
    #array content
    def make_section content
        return {
            type:"mrkdwn",
            text:content
        }
    end

    def sections contents
        _payload[:blocks] << {
            type:"section",
            fields:contents
        }
        self
    end

    def send
        _payload[:blocks] << {
            type:"divider"
        }
        
        uri = URI(_url)
        res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            req = Net::HTTP::Post.new(uri)
            req['Content-Type'] = 'application/json'
            req['Authorization'] = 'Bearer xoxp-198833213056-323448602978-693979208484-c7e39c66216c848c53b9fdfcd1a603e9'
            req.body = _payload.to_json
            d = http.request(req)
        end
    
    end


end