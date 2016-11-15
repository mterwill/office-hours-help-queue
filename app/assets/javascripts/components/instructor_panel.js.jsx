var InstructorPanel = React.createClass({
  buttonBaseClass: "ui bottom padded fluid button ",
  getQueuePopButtonData: function () {
    return {
      title: 'Queue Pop',
      className: this.buttonBaseClass + "huge primary " + (this.props.requests.length <= 0 ? "disabled" : ""),
      action: this.popQueue,
    };
  },
  getInstructorToggleButtonData: function () {
    var instructorOnline = false;

    return {
      title: instructorOnline ?  'Go Offline' : 'Go Online',
      className: this.buttonBaseClass + "large",
    };
  },
  getTakeQueueOfflineButtonData: function () {
    var instructorCount = 0;

    return {
      title: 'Take All Instructors Offline',
      className: this.buttonBaseClass + "large " + (instructorCount <= 0 ? "disabled" : ""),
    };
  },
  render: function () {
    return (
      <div className={this.props.segmentClass}>
        <h4 className="ui header">Instructor Queue Management</h4>

        <Action data={this.getQueuePopButtonData()} />
        <Action data={this.getInstructorToggleButtonData()} />
        <Action data={this.getTakeQueueOfflineButtonData()} />

      </div>
    );
  },
  popQueue: function () {
    this.props.queuePop();
  },
  toggleInstructorStatus: function () {

  }
});
