desc "Daily email notifications"

task :send_delivery_notices => :environment do

  Person.all.introduced(:person, :intro).rel_where(delivery_notice_sent: nil).pluck(:intro).to_a.each do |intro|
    # TODO: be more clever, use tracking data
    # TODO: job not exist (in progress)
    job = LOB.jobs.find(intro.job_id)
    events = job["tracking"]["events"]

    puts events

    if intro.expected_delivery and intro.expected_delivery <= Date.today
      puts intro.from_node.email
      #intro.update(delivery_notice_sent: DateTime.now)
      #UserMailer.new_card(intro.from_node, intro, :type => :delivery).deliver_now
    end
  end

end
