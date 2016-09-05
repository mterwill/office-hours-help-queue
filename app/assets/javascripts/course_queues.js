function getById(id) {
  return $('[data-cable-type=request][data-id=' + id + ']');
}

function render(data) {
  requestElt.data('id', data.id);
}
