require 'sinatra'
require 'pony'

post '/' do
  redirect_url = params.delete('redirect')

  Mailer.mail :to => ENV['MAIL_RECIPIENT'],
              :from_email => params.delete('email') || ENV['MAIL_RECIPIENT'],
              :from_name => params.delete('name'),
              :subject => params.delete('subject'),
              :body => params.to_paragraphs

  redirect(redirect_url || back)
end

module Mailer
  def self.mail(options)
    Pony.mail :to => options[:to],
              :from => from(options[:from_email], options[:from_name]),
              :subject => options[:subject] || '',
              :body => options[:body], 
              :via => :smtp, 
              :via_options => {
                :address => 'smtp.sendgrid.net',
                :port => '25',
                :user_name => ENV['SENDGRID_USERNAME'],
                :password => ENV['SENDGRID_PASSWORD'],
                :authentication => :plain,
                :domain => ENV['SENDGRID_DOMAIN']
              }
  end

  def self.from(email, name = nil)
    name ? "#{name} <#{email}>" : email
  end
end

class Hash
  def to_paragraphs
    paragraphs = []
    each do |k,v|
      paragraphs << [k.to_s.upcase.gsub(/_/, ' '), v.to_s].join("\n\n")
    end
    paragraphs.join "\n\n-----\n\n"
  end
end
