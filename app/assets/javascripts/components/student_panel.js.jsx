var StudentPanel = React.createClass({
  getInitialState: function () {
    return {
      myRequest: this.getState(this.props.myRequest),
    };
  },
  componentWillReceiveProps: function (nextProps) {
    // TODO: this wipes stuff out
    this.setState({
      myRequest: this.getState(nextProps.myRequest),
    });
  },
  getState: function (myRequest) {
    if (myRequest) {
      return myRequest.request;
    } else {
      return {
        location: '',
        description: '',
      };
    }
  },
  update: function (attr, event) {
    var newState = this.state.myRequest;
    newState[attr] = event.target.value;
    this.setState({
      myRequest: newState
    });
  },
  requestHelp: function () {
    this.props.requestHelp({
      location: this.state.myRequest.location,
      description: this.state.myRequest.description,
    });
  },
  cancelRequest: function () {
    this.props.cancelRequest(this.state.myRequest.id);
  },
  renderButton: function () {
    if (this.state.myRequest.hasOwnProperty('created_at')) {
      // existing request
      return (
        <div onClick={this.cancelRequest} className="ui negative fluid button" tabIndex="0">
          Cancel Request
        </div>
      );
    } else {
      return (
        <div onClick={this.requestHelp} className="ui fluid button" tabIndex="0">
          Request Help
        </div>
      );
    }
  },
  render: function () {
    return (
      <div className={this.props.segmentClass}>
        <h4 className="ui header">Request Help</h4>
        <div className="ui form">
          <div className="field">
            <label>Location</label>
            <input disabled={this.state.myRequest.hasOwnProperty('created_at')} onChange={this.update.bind(this, 'location')} value={this.state.myRequest.location} type="text" />
          </div>
          <div className="field">
            <label>Description</label>
            <textarea disabled={this.state.myRequest.hasOwnProperty('created_at')} onChange={this.update.bind(this, 'description')} value={this.state.myRequest.description}
              type="text" rows="2"></textarea>
          </div>
          {this.renderButton()}
        </div>
      </div>
    );
  },
});
