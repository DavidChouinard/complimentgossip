desc "Daily email notifications"

task :send_delivery_notices => :environment do
  Person.all.introduced_by(:person, :intro).where('intro.delivery_notice_sent IS NULL AND intro.job_id IS NOT NULL AND intro.expected_delivery IS NOT NULL AND person.email IS NOT NULL').pluck(:intro).to_a.each do |intro|
    job = LOB.jobs.find(intro.job_id)

    # this shouldn't happen
    if job.nil?
      next
    end

    events = job["tracking"]["events"]

    # filter events too recent

    # no tracking data for non-US, just send on original estimated delivery date
    if job["to"]["address_country"] != "United States"
      if intro.expected_delivery <= Date.today
        send_delivery_email intro
      end
      next
    end

    # these are just a bunch of heuristics

    if events.length >= 4 and intro.expected_delivery >= Date.today - 2.business_day
      send_delivery_email intro
    end

    destination_zip = job["to"]["address_zip"]
    if events.select { |e| e["location"][0,1] == destination_zip[0,1] }.length >= 2 and intro.expected_delivery >= Date.today - 2.business_day
      send_delivery_email intro
    end

    if intro.expected_delivery <= Date.today + 1.business_day
      send_delivery_email intro
    end

  end


  def send_delivery_email(introduction)
    puts introduction.content
    puts intro.from_node.email
    #UserMailer.new_card(intro.from_node, intro, :type => :delivery).deliver_now
    #intro.update(delivery_notice_sent: DateTime.now)
    return
  end

end
