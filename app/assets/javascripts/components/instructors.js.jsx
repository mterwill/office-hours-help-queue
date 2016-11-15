var Instructors = React.createClass({
  render: function () {
    var popup = function (elt) {
      if (elt) $(elt).popup();
    };

    var instructors = this.props.instructors.map(function (instructor) {
      return (
        <img
          className="ui mini avatar image"
          data-popup="true"
          data-content={instructor.name}
          data-position="top center"
          data-variation="inverted"
          src={instructor.avatar_url}
          key={instructor.id}
          ref={popup}
        />
      );
    });

    return (
      <div className="ui right floated images">
        {instructors}
      </div>
    );
  },
});
