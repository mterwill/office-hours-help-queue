// TODO: actual messages
var QueueClosedMessage = React.createClass({
  render: function () {
    if (this.props.instructors.length <= 0) {
      return (
        <div className="sixteen wide column">
          <Message title="Queue Closed" message="The queue is now closed." id="queueClosed" />
        </div>
      )
    } else {
      return null;
    }
  }
});
