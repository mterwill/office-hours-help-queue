var StudentPanel = React.createClass({
  getInitialState: function () {
    return {
      myRequest: this.getState(this.props.myRequest),
      editMode: false,
      disabled: false,
    };
  },
  componentWillReceiveProps: function (nextProps) {
    if (this.props.myRequest || nextProps.myRequest) {
      this.setState({
        myRequest: this.getState(nextProps.myRequest),
      });
    }
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
    if(!this.state.disabled){
      this.props.requestHelp({
        location: this.state.myRequest.location,
        description: this.state.myRequest.description,
      });
  
      this.setState({
        disabled: true
      });
  
      setTimeout(this.enableButton, 10000);
    }
  },
  enableButton: function() {
    this.setState({
      disabled: false
    });
  },
  cancelRequest: function () {
    if (confirm('Are you sure?')) {
      this.props.cancelRequest(this.state.myRequest.id);
    }
  },
  updateRequest: function () {
    this.props.updateRequest(this.state.myRequest);
  },
  renderButton: function () {
    if (this.state.myRequest.hasOwnProperty('created_at') && !this.state.editMode) {
      // existing request
      return (
        <div className="ui two buttons">
          <div onClick={function () { this.setState({editMode: true})}.bind(this)} className="ui fluid button" tabIndex="0">
            Edit
          </div>
          <div onClick={this.cancelRequest} className="ui negative fluid button" tabIndex="1">
            Cancel
          </div>
        </div>
      );
    } else if (this.state.editMode) {
      return (
        <div onClick={function () { this.setState({editMode: false}); this.updateRequest();}.bind(this)} className="ui fluid button" tabIndex="0">
          Save
        </div>
      );
    } else {

      // Three conditionals for three states including helpful text describing state
      if (this.props.queueClosed) {
          var btnClass = "ui basic fluid button"; 
          return (
            <div onClick={this.requestHelp} className={btnClass} tabIndex="0">
              Queue Closed
            </div>
          );      
      }
      else if (this.state.disabled){
          var btnClass = "ui disabled fluid button";
          return (
            <div onClick={this.requestHelp} className={btnClass} tabIndex="0">
              Recently pressed... wait to join queue
            </div>
          );
      }
      else{
          var btnClass = "ui fluid button";
          return (
            <div onClick={this.requestHelp} className={btnClass} tabIndex="0">
              Request Help
            </div>
          );
      }
    }
  },
  render: function () {
    var existingRequest = this.state.myRequest.hasOwnProperty('created_at');
    if (existingRequest && !this.state.editMode) {
      // click the edit button to edit
      var isDisabled = true;
    } else if (this.props.queueClosed && !existingRequest) {
      // you can't make a request into a closed queue
      var isDisabled = true;
    } else {
      // you can make a request in any other case
      var isDisabled = false;
    }

    if (this.props.groupMode) {
      var groupModeLabel = (
          <div className="ui tiny teal label">Group Mode</div>
      );
    }

    return (
      <div className={this.props.segmentClass}>
        <h4 className="ui header">
          Request Help
          {groupModeLabel}
        </h4>
        <div className="ui form">
          <div className="field">
            <label>Location</label>
            <input disabled={isDisabled} onChange={this.update.bind(this, 'location')} value={this.state.myRequest.location} type="text" maxLength="100" />
          </div>
          <div className="field">
            <label>Description</label>
            <textarea disabled={isDisabled} onChange={this.update.bind(this, 'description')} value={this.state.myRequest.description}
              maxLength="100" type="text" rows="2"></textarea>
          </div>
          {this.renderButton()}
        </div>
      </div>
    );
  },
});
