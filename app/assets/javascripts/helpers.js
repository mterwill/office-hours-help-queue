function mapById(arr, id) {
  return arr.map(function (elt) {
    return elt.id;
  }).indexOf(id);
}
