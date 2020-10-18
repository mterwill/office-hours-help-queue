ActiveSupport::Notifications.subscribe('deprecation.rails') do |_name, _start, _finish, _id, payload|
  e = RuntimeError.new(payload[:message])
  Bugsnag.notify(e, {:severity => "warning"}) do |report|
    report.meta_data[:callstack] = payload[:callstack]
  end
end
