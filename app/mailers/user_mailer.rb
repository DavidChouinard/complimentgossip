class UserMailer < ApplicationMailer
  default from: "\"David Chouinard (Compliment Gossip)\" <david@davidchouinard.com>"

  EMOJIS = ['🎉', '😇', '🙇', '😸', '🌝', '🎁', '✨', '📬']

  def new_card(recipient, introduction, type: :parent)
    @introduction = introduction
    @person = recipient
    @children = @person.rels(dir: :outgoing)

    if (type == :parent)
      subject = "#{@introduction.from_node.first_name} passed along a card #{EMOJIS.sample}"
    else
      subject = "#{@introduction.to_node.first_name} should be receiving your card today #{EMOJIS.sample}"
      # about now
    end

    mail(to: @person.email, subject: subject)
  end

end
