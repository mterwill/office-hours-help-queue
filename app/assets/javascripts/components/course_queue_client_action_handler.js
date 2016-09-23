/**
 * Fired by click events to collect relevant data and dispatch an RPC to the
 * server via ActionCable's perform() method.
 */
function CourseQueueClientActionHandler(subscription) {
  this.subscription = subscription;
}

CourseQueueClientActionHandler.prototype.newRequest = function (selector) {
  var form = $(selector).parent();

  var location    = form.find('input[name=location]').val();
  var description = form.find('textarea[name=description]').val();

  this.subscription.perform('new_request', {
    location: location,
    description: description,
  });
};

CourseQueueClientActionHandler.prototype.queuePop = function (selector) {
  this.subscription.perform('queue_pop');
};

CourseQueueClientActionHandler.prototype.instructorStatusToggle = function (selector) {
  var newStatus = !$(selector).data('online');

  $(selector).data('online', newStatus);

  this.subscription.perform('instructor_status_toggle', {
    online: newStatus,
  });
};

CourseQueueClientActionHandler.prototype.resolveRequest = function (request) {
  this.subscription.perform('resolve_request', {
    id: request.id,
  });
};

CourseQueueClientActionHandler.prototype.destroyRequest = function (selector) {
  var requestId = $(selector).data('id');

  this.subscription.perform('destroy_request', {
    id: requestId,
  });
};
