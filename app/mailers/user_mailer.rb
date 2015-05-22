class UserMailer < ApplicationMailer
  # TODO: name
  # David Chouinard (Compliment Gossip)
  default from: 'david@davidchouinard.com'


  def new_card(recipient, introduction)
    @introduction = introduction
    @recipient = recipient
    mail(to: recipient.email, subject: 'Welcome to My Awesome Site')
    # David should be receiving your card today
    #
    # David passed along a card
    #
    # random emoji
  end

end
