desc "Daily email notifications"

namespace :notify do
  task :send_delivery_notices => :environment do

    TIME_CUTOFF = 6  # consider events before 6am CT as pertaining to the day before

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
        if intro.expected_delivery <= Time.zone.today
          send_delivery_email intro, hedge: true
        end
        next
      end

      # these are just a bunch of heuristics

      if events.length >= 4 and intro.expected_delivery >= 2.business_days.before(Time.zone.today)
        send_delivery_email intro
        next
      end

      if events.select { |e|
          e["location"][0,1] == job["to"]["address_zip"][0,1] &&
          Date.parse(e["time"]) <= 1.business_days.before(Time.zone.today).to_datetime.change({ hour: TIME_CUTOFF, offset: "-0600"})
        }.length >= 2 and intro.expected_delivery >= 2.business_days.before(Date.today)
          send_delivery_email intro
          next
      end

      if intro.expected_delivery <= 1.business_day.after(Time.zone.today)
        send_delivery_email intro
      end

    end

  end

  def send_delivery_email(introduction, hedge: false)
    puts introduction.from_node.email
    UserMailer.new_card(introduction.from_node, introduction, :type => :delivery, :hedge_on_estimate => hedge).deliver_now
    #intro.update(delivery_notice_sent: DateTime.now)
  end

  task :populate_mixpanel => :environment do
    mixpanel = Mixpanel::Tracker.new("bfd59c67d03d9d1763a9301bf838de31")

    Person.all.each do |person|
      if person.name
        mixpanel.people.set(person.uuid, {
          '$name' => person.name,
          'Address' => "#{person.city}, " + if person.country == "US" then person.state else person.country end,
          '$created' => person.created_at,
          '$city' => person.city,
          '$region' => person.state,
          '$country' => person.country
        })

        if person.email
          mixpanel.people.set(person.uuid, {
            '$email' => person.email
          })
        end
      end
    end
  end
end
