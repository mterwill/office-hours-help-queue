var Request = React.createClass({
  getInitialState: function () {
    return {
      ts: this.props.request.created_at,
    };
  },
  ref: function (ref) {
    if (ref) {
      this.clippy = new Clipboard(ref);
    } else if (this.clippy) {
      this.clippy.destroy();
    }
  },
  componentWillMount: function () {
    this.updateMomentTimestamp();
    this.interval = setInterval(this.updateMomentTimestamp, 300);
  },
  componentWillUnmount: function () {
    clearInterval(this.interval);
  },
  updateMomentTimestamp: function () {
    this.setState({
      ts: moment(this.props.request.created_at).fromNow(),
    });
  },
  render: function () {
    var actions;
    if (this.props.resolve) {
      actions = (
        <Actions>
          <Action data={{ title: 'Resolve', action: this.props.resolve.bind(null, this.props.request.id)}} />
          <Action data={{ title: 'Bump', action: this.props.bump.bind(null, this.props.request.id)}} />
        </Actions>
      );
    }

    return (
      <div className="comment">
        <Avatar url={this.props.request.requester.avatar_url} />
        <div className="content">
          <span className="author">{this.props.request.requester.name}</span>
          <a ref={this.ref} href="" onClick={function (e) { e.preventDefault(); }}
             data-clipboard-text={this.props.request.requester.email}
             className="metadata">{this.props.request.requester.email}</a>
          <div className="ui slightly padded list">
            <LabeledItem icon="clock">{this.state.ts}</LabeledItem>
            <LabeledItem icon="marker">{this.props.request.location}</LabeledItem>
            <LabeledItem icon="write">{this.props.request.description}</LabeledItem>
          </div>
          {actions}
        </div>
      </div>
    );
  },
});
