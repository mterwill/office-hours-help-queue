json.array! @outstanding_requests do |request|
    json.merge! serialize_request(request)
end
