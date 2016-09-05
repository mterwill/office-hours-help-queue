$(document).ready(function () {
  App.cable.subscriptions.create({
    channel: "QueueChannel",
    id: $('#course-queue-name').data('course-queue-id')
  }, {
    handleAction: function (e) {
      const action = $(this).data('cable-action');
      const _this  = e.data;

      if (action === 'new_request') {
        _this.newRequest(this);
      } else if (action === 'destroy_request') {
        _this.destroyRequest(this);
      } else if (action === 'resolve_request') {
        _this.resolveRequest(this);
      }
    },
    newRequest: function (selector) {
      const form = $(selector).parent();

      const location    = form.find('input[name=location]').val();
      const description = form.find('textarea[name=description]').val();

      this.perform('new_request', {
        location: location,
        description: description,
      });
    },
    destroyRequest: function (selector) {
      const requestId = $(selector).closest('[data-cable-type=request]').data('id');

      this.perform('destroy_request', {
        id: requestId,
      });
    },
    connected: function () {
      $(document).on(
        'click',
        '[data-cable-action]',
        this,
        this.handleAction
      );

      $('[data-cable-container="requests"]').children().not('script').remove();

      getOutstandingRequests();

    },
    disconnected: function () {
      $('[data-cable-container="requests"]').closest('.ui.segment').addClass('disabled loading');
      $('[data-cable-container="requests"]').hide();
      $('[data-cable-container="requests-count"]').hide();
    },
    received: function (data) {
      if (data.action === 'new_request') {
        const elt = renderRequest(data.request);

        elt.appendTo('[data-cable-container=requests]');

        updateCount(data.outstanding_request_count);
      } else if (data.action === 'destroy_request') {
        const selector = '[data-cable-type=request][data-id=' + data.request.id + ']';

        $(selector).detach();
        updateCount(data.outstanding_request_count);
      }

      $('#queue-count').html(data.outstanding_request_count);
    },
  });
});
