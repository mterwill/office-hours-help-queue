var StudentPanel = React.createClass({
  getInitialState: function () {
    return {
      location: '',
      description: '',
    }
  },
  update: function (attr, event) {
    var newState = {}
    newState[attr] = event.target.value;
    this.setState(newState);
  },
  requestHelp: function () {
    this.props.requestHelp({
      location: this.state.location,
      description: this.state.description,
    })
  },
  render: function () {
    return (
      <div className={this.props.segmentClass}>
        <h4 className="ui header">Request Help</h4>
        <div className="ui form">
          <div className="field">
            <label>Location</label>
            <input onChange={this.update.bind(this, 'location')} value={this.state.location} type="text" />
          </div>
          <div className="field">
            <label>Description</label>
            <textarea onChange={this.update.bind(this, 'description')} value={this.state.description}
              type="text" rows="2"></textarea>
          </div>
          <div onClick={this.requestHelp} className="ui fluid button" tabIndex="0">
            Request Help
          </div>
        </div>
      </div>
    );
  },
});
