var Header = React.createClass({
  render: function () {
    var queueLoc;
    if (this.props.queueLoc) {
      var queueLoc = (
          <small>({this.props.queueLoc})</small>
      );
    }

    return (
      <h1 className="ui left floated header">
        {this.props.courseName}
        <div className="sub header">
          {this.props.queueName} {queueLoc}
        </div>
      </h1>
    );
  },
});
