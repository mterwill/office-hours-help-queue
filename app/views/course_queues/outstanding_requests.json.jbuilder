json.array! @outstanding_requests do |request|
    json.merge! redact_request(serialize_request(request), current_user)
end
