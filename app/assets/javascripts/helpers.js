function mapById(arr, id) {
  return arr.map(function (elt) {
    return elt.id;
  }).indexOf(id);
}

function copyArr(initial) {
  // splice returns the elements removed from the array, we want the opposite.
  // to make sure the state stays clean, copy the array, remove the element,
  // then update the state.
  return initial.slice();
}
