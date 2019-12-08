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
  getRequesterNameString: function () {
    if (this.props.request.requester.nickname) {
      return `${this.props.request.requester.name} (${this.props.request.requester.nickname})`;
    } else {
      return this.props.request.requester.name;
    }
  },
  render: function () {
    var actions;
    if (this.props.resolve) {
      var pinText = this.props.request.resolver_id === null ? 'Pin' : 'Unpin';

      actions = (
        <Actions>
          <Action data={{ title: 'Resolve', action: this.props.resolve.bind(null, this.props.request.id)}} />
          <Action data={{ title: pinText, action: this.props.pin.bind(null, this.props.request.id)}} />
          <Action data={{ title: 'Ping', action: this.props.bump.bind(null, this.props.request.id)}} />
        </Actions>
      );
    }

    var active = "";
    var isUserRequester  = this.props.request.requester.id === this.props.currentUserId;
    var isGroupRequester = this.props.request.course_group_id === this.props.currentGroupId;
    if (isUserRequester || (this.props.currentGroupId && isGroupRequester)) {
      active = 'active ';
    }

    let pinnedByUser;
    if (this.props.request.resolver) {
      pinnedByUser = (
        <LabeledItem icon="bookmark">
          Pinned by {this.props.request.resolver.name}
        </LabeledItem>
      );
    }

    if (this.props.isAnonymous){
      return (
        <div className={active + "comment"}>
          <Avatar url='https://i.imgur.com/QKLaN13.png' />
          <div className="content">
            <span className="author">Anonymous</span>
            <a ref={this.ref} href="" onClick={function (e) { e.preventDefault(); }}
              data-clipboard-text='anonymous@umich.edu'
              className="metadata">anonymous@umich.edu</a>
            <div className="ui slightly padded list">
              <LabeledItem icon="clock">{this.state.ts}</LabeledItem>
              <LabeledItem icon="marker">{this.props.request.location}</LabeledItem>
              <LabeledItem icon="write">{this.props.request.description}</LabeledItem>
              {pinnedByUser}
            </div>
            {actions}
          </div>
        </div>
      );
    } else {
      return (
        <div className={active + "comment"}>
          <Avatar url={this.props.request.requester.avatar_url} />
          <div className="content">
            <span className="author">{this.getRequesterNameString()}</span>
            <a ref={this.ref} href="" onClick={function (e) { e.preventDefault(); }}
              data-clipboard-text={this.props.request.requester.email}
              className="metadata">{this.props.request.requester.email}</a>
            <div className="ui slightly padded list">
              <LabeledItem icon="clock">{this.state.ts}</LabeledItem>
              <LabeledItem icon="marker">{this.props.request.location}</LabeledItem>
              <LabeledItem icon="write">{this.props.request.description}</LabeledItem>
              {pinnedByUser}
            </div>
            {actions}
          </div>
        </div>
      );
    }
  },
});
