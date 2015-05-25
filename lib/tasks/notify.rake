desc "Daily email notifications"

namespace :notify do
  task :send_delivery_notices => :environment do

    TIME_CUTOFF = 7  # consider events before 7am CT as pertaining to the day before

    Person.all.introduced_by(:person, :intro).where('intro.delivery_notice_sent IS NULL AND intro.job_id IS NOT NULL AND intro.expected_delivery IS NOT NULL AND person.email IS NOT NULL').pluck(:intro).to_a.each do |intro|
      job = LOB.jobs.find(intro.job_id)

      # this shouldn't happen
      if job.nil?
        next
      end

      events = job["tracking"]["events"]

      expected_delivery_date = Date.parse(job["expected_delivery_date"])

      # no tracking data for non-US, just send on original estimated delivery date
      if job["to"]["address_country"] != "United States"
        if expected_delivery_date <= Time.zone.today
          send_delivery_email intro, hedge: true
        end
        next
      end

      # these are just a bunch of heuristics

      if events.length >= 4 and expected_delivery_date >= 2.business_days.before(Time.zone.today)
        send_delivery_email intro
        next
      end

      if events.select { |e|
          e["location"][0,1] == job["to"]["address_zip"][0,1] &&
          DateTime.parse(e["time"]) <= 1.business_days.before(Time.zone.today).to_datetime.change({ hour: TIME_CUTOFF, offset: "-0600"})
        }.length >= 2 and expected_delivery_date >= 2.business_days.before(Date.today)
          send_delivery_email intro
          next
      end

      if expected_delivery_date <= 1.business_day.before(Time.zone.today)
        send_delivery_email intro
      end

    end

  end

  def send_delivery_email(introduction, hedge: false)
    UserMailer.new_card(introduction.from_node, introduction, :type => :delivery, :hedge_on_estimate => hedge).deliver_now

    introduction.expected_delivery = Date.today
    introduction.delivery_notice_sent = DateTime.now
    introduction.save
  end
end
