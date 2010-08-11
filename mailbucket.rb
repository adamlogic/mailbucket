require 'sinatra'
require 'pony'

post '/' do
  Mailer.mail :to => ENV['MAIL_RECIPIENT'],
              :from_email => params.delete(:email) || ENV['MAIL_RECIPIENT'],
              :from_name => params.delete(:name),
              :subject => params.delete(:subject),
              :body => params.to_paragraphs

  redirect back
end

module Mailer
  def self.mail(options)
    Pony.mail :to => options[:to],
              :from => options[:from] || from(options[:email], options[:name]),
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
    paragraphs = ''
    each do |k,v|
      paragraphs << [ k.to_s.upcase, '', v.to_s, '' ].join("\n")
    end
    paragraphs
  end
end
