# Use Case

I had a Jekyll site (static, on GH pages) which needed to post a form and have an email be sent.
Just a simple contact form.  This app can be deployed and used as a service to receive the form post
and send the email.  It is made to work with Heroku out of the box.

# Usage

Post a form to the root path of your mailbucket app.  You can include the following parameters (all are optional):

* _subject_ - The subject of the email.  Will be blank if not provided.
* _name_ - The name of the sender.
* _email_ - The email address of the sender.
* _redirect_ - The URL to redirect to after sending the email.  Redirects to the referrer if not provided.

All remaining parameters will be formatted and used as the body of the email.

# Heroku

    heroku create mymailbucket
    git push heroku
    heroku addons:add sendgrid:free
    heroku config:add MAIL_RECIPIENT:where_to_send@email.com
