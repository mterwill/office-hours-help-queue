// TODO: function findContainerFor()
const requestsContainerSelector       = '[data-cable-container="requests"]';
const requestsCountContainerSelector  = '[data-cable-container="requests-count"]';
const actionContentContainerSelector  = '[data-cable-container="action-content"]';

/**
 * Remove everything from the requests container.
 */
function emptyRequestsContainer() {
  $(requestsContainerSelector).children().not('script').remove();
}

/**
 * Alter contextual hints on page state.
 */
function disablePage() {
  $(requestsContainerSelector).hide();
  $(requestsCountContainerSelector).hide();
  $(requestsContainerSelector).closest('.ui.segment').addClass('disabled loading');
  $(actionContentContainerSelector).closest('.ui.segment').addClass('disabled loading');
}

/**
 * Alter contextual hints on page state.
 */
function enablePage() {
  $(requestsContainerSelector).show();
  $(requestsCountContainerSelector).show();
  $(requestsContainerSelector).closest('.ui.segment').removeClass('disabled loading');
  $(actionContentContainerSelector).closest('.ui.segment').removeClass('disabled loading');
}

/**
 * Perform common, idempotent, cheap tasks to make sure our page data stays in
 * sync. This function should be called whenever data is changed.
 */
function fixupPage() {
  let newCount = updateRequestsCount();

  if (newCount === 0) {
    renderEmptyRequests();
  } else {
    // handled in renderRequest()
  }

  if ($('[data-requester-id=' + getCurrentUserId() + ']').length === 0) {
    renderHelpForm();
  } else {
    // handled in renderRequest()
  }
  
  enablePage();
}

/**
 * Count the number of requests currently present in the container.
 */
function getRequestsCount() {
  return $(requestsContainerSelector).children().not('[data-dont-count]').length;
}

/**
 * Update the badge count with the number of requests currently in the
 * container.
 *
 * TODO: this could listen for changes on the container.
 */
function updateRequestsCount() {
  let count = getRequestsCount();

  $(requestsCountContainerSelector).html(count);

  return count;
}

/**
 * Render a request based on the template and append it to the requests
 * container.
 */
function renderRequest(request) {
  renderTemplate(
    'request',
    'requests',
    getRequestsCount() > 0,
    function (elt) {
      elt.attr('data-id', request.id);
      elt.attr('data-requester-id', request.requester_id);

      elt.find('[data-field="requester.avatar_url"]').attr('src', request.requester.avatar_url);
      elt.find('[data-field="requester.name"]').html(request.requester.name);
      elt.find('[data-field="requester.email"]').html(request.requester.email);
      elt.find('[data-field="location"]').html(request.location);
      elt.find('[data-field="created_at"]').html(request.created_at);
      elt.find('[data-field="description"]').html(request.description);

      elt.find('[data-cable-action]').data('id', request.id);

      if (isCurrentUserInstructor() === false) {
        elt.find('[data-require-privilege="instructor"]').remove();
      }
    }
  );

  if (getCurrentUserId() === request.requester_id) {
    renderMyRequest(request);
  }
}

/**
 * Render a blank help request form.
 */
function renderHelpForm() {
  renderTemplate('help_request_form', 'action-content', false);
}

/**
 * Replace the contents of a help request form with information on a request for
 * the current user. Note a limitation here is that we cannot support multiple
 * requests from a single user.
 */
function renderMyRequest(request) {
  renderTemplate('my-request', 'action-content', false, function (elt) {
    elt.find('input[name="location"]').val(request.location);
    elt.find('textarea[name="description"]').val(request.description);

    elt.find('[data-cable-action]').data('id', request.id);
  });
}

/**
 * Used to backfill any pre-existing requests from before the course queue page
 * was loaded. ActionCable will stream in new ones.
 */
function getOutstandingRequests(queueId, callback) {
  $.ajax({
    url: '/course_queues/' + queueId + '/outstanding_requests.json'
  }).done(callback);
}

/**
 * Accept a template (must be in the dom somewhere with data attribute
 * `cable-template` and a container (with data attribute `cable-container`).
 * Either append or overwrite the container contents. Optionally munge the
 * template to insert any item-specific data via callback.
 */
function renderTemplate(template, parentContainer, append = true, munge = null) {
  let parentElt = $('[data-cable-container="' + parentContainer + '"]');
  let templateElt = $('[data-cable-template="' + template + '"]');
  let elt       = $(templateElt.html());

  if (munge !== null) {
    munge(elt);
  }

  if (append) {
    parentElt.append(elt);
  } else {
    parentElt.html(elt);
  }
}

/**
 * Render the empty requests template in the requests container.
 */
function renderEmptyRequests() {
  renderTemplate('empty', 'requests', false);
}

/**
 * Find a request by ID and return the corresponding jQuery object.
 */
function findRequestById(id) {
  return $('[data-cable-type=request][data-id=' + id + ']');
}

/**
 * Find a request by ID and remove it from the DOM.
 */
function deleteRequestById(id) {
  findRequestById(id).detach();
}

/**
 * Find the current user's id. All validation must be done server-side, this is
 * just for presenting UI elements.
 */
function getCurrentUserId() {
  return $('[data-current-user-id]').data('current-user-id');
}

/**
 * Find if the current user is an instructor for this course.  All validation
 * must be done server-side, this is just for presenting UI elements.
 */
function isCurrentUserInstructor() {
  return $('[data-current-user-instructor]').data('current-user-instructor');
}
