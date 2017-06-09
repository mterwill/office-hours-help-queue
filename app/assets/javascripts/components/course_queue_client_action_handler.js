/**
 * Fired by click events to collect relevant data and dispatch an RPC to the
 * server via ActionCable's perform() method.
 */
function CourseQueueClientActionHandler(subscription) {
  this.subscription = subscription;
}

CourseQueueClientActionHandler.prototype.newRequest = function (data) {
  this.subscription.perform('new_request', data);
};

CourseQueueClientActionHandler.prototype.updateRequest = function (data) {
  this.subscription.perform('update_request', data);
};

CourseQueueClientActionHandler.prototype.queuePop = function () {
  this.subscription.perform('queue_pop');
};

CourseQueueClientActionHandler.prototype.takeQueueOffline = function () {
  this.subscription.perform('take_queue_offline');
};

CourseQueueClientActionHandler.prototype.emptyQueue = function () {
  this.subscription.perform('empty_queue');
};

CourseQueueClientActionHandler.prototype.bump = function (requestId) {
  this.subscription.perform('bump', {
    id: requestId,
  });
};

CourseQueueClientActionHandler.prototype.pin = function (requestId) {
  this.subscription.perform('pin', {
    id: requestId,
  });
};

CourseQueueClientActionHandler.prototype.setInstructorStatus = function (newStatus) {
  this.subscription.perform('instructor_status_toggle', {
    online: newStatus,
  });
};

CourseQueueClientActionHandler.prototype.resolveRequest = function (requestId) {
  this.subscription.perform('resolve_request', {
    id: requestId,
  });
};

CourseQueueClientActionHandler.prototype.cancelRequest = function (id) {
  this.subscription.perform('destroy_request', {
    id: id,
  });
};

CourseQueueClientActionHandler.prototype.broadcastMessage = function (action, message) {
  this.subscription.perform(action, {
    message: message
  });
};
