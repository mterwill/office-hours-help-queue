var Request = React.createClass({
  render: function () {
    return (
      <div className="comment">
        <Avatar url={this.props.request.requester.avatar_url} />
        <div className="content">
          <span className="author">{this.props.request.requester.name}</span>
          <span className="metadata">{this.props.request.requester.email}</span>
          <div className="ui slightly padded list">
            <LabeledItem icon="clock">{this.props.request.created_at}</LabeledItem>
            <LabeledItem icon="marker">{this.props.request.location}</LabeledItem>
            <LabeledItem icon="write">{this.props.request.description}</LabeledItem>
          </div>
          <Actions>
            <Action title="Resolve" onClick={this.resolveRequest} />
          </Actions>
        </div>
      </div>
    );
  },
  resolveRequest: function () {
    this.props.handler.resolveRequest(this.props.request);
  }
});
