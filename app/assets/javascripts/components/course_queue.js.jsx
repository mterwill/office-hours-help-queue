var CourseQueue = React.createClass({
  enable: function () {
    this.setState({ enabled: true });
  },
  disable: function () {
    this.setState({ enabled: false });
  },
  pushRequest: function (request) {
    this.setState({
      requests: this.state.requests.concat([request])
    });
  },
  removeRequest: function (request) {
    var index = this.state.requests.map(function (elt) {
      return elt.id;
    }).indexOf(request.id);

    this.setState({
      requests: this.state.requests.splice(index, 1)
    });
  },
  componentWillMount: function () {
    getOutstandingRequests(this.props.id, function (requests) {
      this.setState({requests: requests});
    }.bind(this));

    var courseQueueSubscription = App.cable.subscriptions.create({
      channel: 'QueueChannel',
      id: this.props.id
    }, {
      connected: function () {
        this.enable();
      }.bind(this),
      disconnected: function () {
        this.disable();
      }.bind(this),
      received: function (data) {
        if (data.action === 'new_request') {
          this.pushRequest(data.request);
        } else if (data.action === 'resolve_request') {
          this.removeRequest(data.request);
        } else if (data.action === 'instructor_offline') {
          // TODO
          deleteInstructorById(data.instructor.id);
        } else if (data.action === 'instructor_online') {
          // TODO
          renderInstructor(data.instructor);
        }
      },
    });

    this.handler = new CourseQueueClientActionHandler(courseQueueSubscription);
  },
  render: function () {
    var disabled = this.state.enabled ? '' : 'disabled loading ';

    return (
      <div className="sixteen wide column">
        <div className={'ui ' + disabled + 'min segment'}>
        </div>
      </div>
    );
  }
});
