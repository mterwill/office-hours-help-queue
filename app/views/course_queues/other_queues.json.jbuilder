json.array! @queues do |queue|
    json.merge! serialize_queue(queue)
end
