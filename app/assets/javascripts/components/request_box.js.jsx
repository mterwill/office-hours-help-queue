var RequestBox = React.createClass({
  getInitialState: function() {
    return {
      data: []
    };
  },
  enable: function () {
    this.setState({ enabled: true });
  },
  disable: function () {
    this.setState({ enabled: false });
  },
  pushRequest: function (request) {
    this.setState({
      data: this.state.data.concat([request])
    });
  },
  removeRequest: function (request) {
    var index = this.state.data.map(function (elt) {
      return elt.id;
    }).indexOf(request.id);

    this.setState({
      data: this.state.data.splice(index, 1)
    });
  },
  componentWillMount: function() {
    this.queueId = $('#course-queue-name').data('course-queue-id');

    getOutstandingRequests(this.queueId, function (data) {
      this.setState({data: data});
    }.bind(this));

    var courseQueueSubscription = App.cable.subscriptions.create({
      channel: 'QueueChannel',
      id: this.queueId
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
      }.bind(this),
    });

    this.handler = new CourseQueueClientActionHandler(courseQueueSubscription);
  },
  render: function() {
    var disabled = this.state.enabled ? '' : 'disabled loading ';
    return (
      <div className={'ui ' + disabled + 'min segment'}>
        <h4 className="ui header">
          Queue
          <RequestCountLabel count={this.state.data.length} />
        </h4>
        <RequestList data={this.state.data} handler={this.handler} />
      </div>
    );
  }
});
