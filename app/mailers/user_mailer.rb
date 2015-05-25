class UserMailer < ApplicationMailer
  default from: "\"David Chouinard (Compliment Gossip)\" <david@davidchouinard.com>"

  EMOJIS = ['🎉', '😇', '🙇', '😸', '🌝', '🎁', '✨', '📬']

  def new_card(recipient, introduction, type: :parent, hedge_on_estimate: false)
    @introduction = introduction
    @person = recipient
    @children = @person.rels(dir: :outgoing)

    incoming = @person.rels(dir: :incoming)

    if @person.email.nil? or incoming.empty?
      return
    end

    @key = incoming[0].key

    if (type == :parent)
      subject = "#{@introduction.from_node.first_name} passed along a card #{EMOJIS.sample} "
    else
      subject = "#{@introduction.to_node.first_name} should be "

      if hedge_on_estimate
        subject += "about to receive your card "
      else
        subject += "receiving your card today "
      end

      subject += EMOJIS.sample + " "   # trailing space required to deal with an emoji bug in Apple mail
    end

    mail(to: @person.email, subject: subject)
  end

end
