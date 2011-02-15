require 'rubygems'
require 'twitter'
require 'twitter_oauth'

class TwitterSend

def initialize(event)
          urlstr = "http://bit.ly/g5iFka"
          handle = event.organizer.twitter_handle ##  create method to return handle without exposing organizer
          message = event.title + " at " + event.short_location + " on " + event.date.strftime("%d/%m/%Y") + " " + urlstr
         
          with_message(handle,message)
end

def with_message(handle,message)
  if Rails.env.development?
    handle = 'seantwitter'
    consumer_key = 'us4M46Ccc6GRkX2ukOyCQ'
    consumer_secret = 'SdrDi3sc4B1b7g1TLYI2H7as7b07d7TYboSFZs'
    token = '6749582-D2ObpHnuoavOUDfIpqDbs7MEK7Q08GJEckBDuAXEtJ'
    secret = 'HKYlZXLsSADpcLMyEFPkIHeCG34kZeNVRfRe7fz5kw'
  else
    consumer_key = '43DnloztUFck2UpTfN17Q'
    consumer_secret = 'UZSOhR5LnPOoJSIOkrfyjJfz6u908QQXQbxMyjyphM'
    token = '252655570-cDp9JluHr9KWckvrsN7ad8ifKidC3Rc4X95otmy3'
    secret = 'VLCj0AmjbFHPPUMt2Yf1oZ2lYUTv8OtkzNN3ACEwJOc'
  end
   client = TwitterOAuth::Client.new(
    :consumer_key => consumer_key,
    :consumer_secret => consumer_secret,
    :token => token,
    :secret => secret
   )

  mess = client.message(handle,message)
  if !mess["error"].nil?
    raise "But Tweet was not sent."
  end
  client.update(mess["text"])
end

end