// TODO: actual messages
var QueueClosedMessage = React.createClass({
  render: function () {
    if (this.props.enabled && !this.props.instructorsAvailable) {
      return (
        <div className="sixteen wide column">
          <Message title="Queue Closed" message="The queue is now closed." id="queueClosed" />
        </div>
      )
    } else if (this.props.enabled && !this.props.userAuthorizedToEnqueue) {
      return (
        <div className="sixteen wide column">
          <Message title="Not Authorized" message="You are not authorized to use this queue." id="queueClosed" />
        </div>
      )
    } else {
      return null;
    }
  }
});
