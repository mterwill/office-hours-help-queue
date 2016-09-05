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
      const requestId = $(selector).data('id');

      this.perform('destroy_request', {
        id: requestId,
      });
    },
    connected: function () {
      // Register a generic event handler on everything with this attribute.
      // Pass the current context into the event handler to eventually call
      // this.perform, which sends the RPC.
      //
      // NOTE: this event handler will also need to be attached to any
      // new/updated coming in which do not have it.
      $('[data-cable-action]').click(this, this.handleAction);
    },
    received: function (data) {
      if (data.action === 'new_request') {
        const containerSelector = $('.ui.comments');

        const elt = containerSelector.append(data.data);

        console.log(elt);

        // $('[data-cable-action]').click(this, this.handleAction);
      } else if (data.action === 'destroy_request') {
        const selector = '[data-cable-type=request][data-id=' + data.request.id + ']';

        $(selector).detach();
      }

      $('#queue-count').html(data.outstanding_request_count);
    },
  });
});
