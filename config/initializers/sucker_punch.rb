Rails.application.configure do
  config.active_job.queue_adapter = :sucker_punch
end

SuckerPunch.exception_handler { |ex| Airbrake.notify(ex) }
