var InstructorPanel = React.createClass({
  buttonBaseClass: "ui bottom padded fluid button ",
  getQueuePopButtonData: function () {
    return {
      title: 'Queue Pop',
      className: this.buttonBaseClass + "huge primary " + (this.props.requests.length <= 0 ? "disabled" : ""),
      action: this.props.queuePop,
    };
  },
  getQueuePinTopData: function () {
    return {
      title: 'Queue Pin Top',
      className: this.buttonBaseClass + "huge primary " + (this.props.pinTopRequest === null ? "disabled" : ""),
      action: this.props.pinTopRequest,
    };
  },
  getInstructorToggleButtonData: function () {
    return {
      title: this.props.online ?  'Go Offline' : 'Go Online',
      className: this.buttonBaseClass + "large",
      action: this.props.setInstructorStatus.bind(null, !this.props.online),
    };
  },
  emptyQueueButtonData: function () {
    return {
      title: 'Empty Queue',
      className: this.buttonBaseClass + "large " + (this.props.queueLength <= 0 ? "disabled" : ""),
      action: function () {
        if (confirm('Are you sure? This will permanently delete ' + this.props.queueLength + ' request(s).')) {
          this.props.emptyQueue();
        }
      }.bind(this),
    };

  },
  getTakeQueueOfflineButtonData: function () {
    var instructorCount = this.props.instructors.length;

    return {
      title: 'Take All Instructors Offline',
      className: this.buttonBaseClass + "large " + (instructorCount <= 0 ? "disabled" : ""),
      action: function () {
        if (confirm('Are you sure?')) {
          this.props.takeQueueOffline();
        }
      }.bind(this),
    };
  },
  render: function () {
    return (
      <div className={this.props.segmentClass}>
        <h4 className="ui header">Instructor Queue Management</h4>

        <Action data={this.getQueuePopButtonData()} />
        <Action data={this.getQueuePinTopData()} />
        <Action data={this.getInstructorToggleButtonData()} />
        <Action data={this.getTakeQueueOfflineButtonData()} />
        <Action data={this.emptyQueueButtonData()} />
        

      </div>
    );
  },
});
