$(document).ready(function () {
  const elt = renderHelpForm();

  elt.appendTo('[data-cable-container="action-content"]');

  $('[data-cable-container="action-content"]').closest('.ui.segment').removeClass('disabled loading');
});

function renderHelpForm() {
    const template = $('[data-cable-template="help_request_form"]');
    const elt      = $(template.html());

    return elt;
}

function renderMyRequest(request) {
    const template = $('[data-cable-template="my-request"]');
    const elt      = $(template.html());

    elt.find('input[name="location"]').val(request.location);
    elt.find('textarea[name="description"]').val(request.description);

    $('[data-cable-container="action-content"]').html(elt);

    $('[data-cable-container="action-content"]').closest('.ui.segment').removeClass('disabled loading');
}


function renderRequest(request) {
    const template = $('[data-cable-template=request]');
    const elt      = $(template.html());

    elt.attr('data-id', request.id);

    elt.find('[data-field="requester.avatar_url"]').attr('src', request.requester.avatar_url);
    elt.find('[data-field="requester.name"]').html(request.requester.name);
    elt.find('[data-field="requester.email"]').html(request.requester.email);
    elt.find('[data-field="location"]').html(request.location);
    elt.find('[data-field="created_at"]').html(request.created_at);
    elt.find('[data-field="description"]').html(request.description);

    return elt;
}

function updateCount(count) {
  $('[data-cable-container="requests-count"]').html(count);
}

function getOutstandingRequests() {
  $.ajax({
    url: "/course_queues/715429725/outstanding_requests.json"
  }).done(function (data) {
    data.forEach(function (request) {
      const elt = renderRequest(request);

      elt.appendTo('[data-cable-container=requests]');


      let userId = $('#course-queue-name').data('user-id');
      if (request.requester_id === userId) {
        renderMyRequest(request);
      }
    });

    updateCount(data.length);

    $('[data-cable-container="requests"]').show();
    $('[data-cable-container="requests-count"]').show();

    $('[data-cable-container="requests"]').closest('.ui.segment').removeClass('disabled loading');
  });
}
