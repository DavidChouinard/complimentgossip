class UserMailer < ApplicationMailer
  # TODO: name
  default from: 'david@davidchouinard.com'


  def new_card_email(recipient, introduction)
    @introduction = introduction
    @recipient = recipient
    mail(to: recipient.email, subject: 'Welcome to My Awesome Site')
    # David should be receiving your Compliment Gossip card today!
    #
    # David passed along a Compliment Gossip card
  end

end
