var CourseQueue = React.createClass({
  getInitialState: function () {
    return {
      enabled: false,
      instructorMode: this.props.instructor,
      requests: [],
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
      requests: this.state.requests.concat([request])
    });
  },
  removeRequest: function (request) {
    var index = this.state.requests.map(function (elt) {
      return elt.id;
    }).indexOf(request.id);

    // splice returns the elements removed from the array, we want the opposite.
    // to make sure the state stays clean, copy the array, remove the element,
    // then update the state.
    var arrCopy = this.state.requests.slice();
    console.log(arrCopy);
    arrCopy.splice(index, 1);

    this.setState({
      requests: arrCopy,
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
      }.bind(this),
    });

    this.handler = new CourseQueueClientActionHandler(courseQueueSubscription);
  },
  setMode: function (mode) {
    if (!this.props.instructor) return;

    this.setState({
      instructorMode: mode,
    });
  },
  getMyFirstRequest: function () {
    var index = this.state.requests.map(function (elt) {
      return elt.requester_id;
    }).indexOf(this.props.current_user_id);

    if (index >= 0) {
      return {
        request: this.state.requests[index],
        resolver: this.handler.resolveRequest.bind(this.handler, this.state.requests[index].id),
      }
    }

    return null;
  },
  renderLeftPanel: function (segmentClass, columnClass) {
    var panel, instructorButton, studentButton, buttons;

    if (this.props.instructor && this.state.instructorMode) {
      instructorButton = 'active';
      panel = (
        <InstructorPanel
          segmentClass={segmentClass}
          requests={this.state.requests}
          queuePop={this.handler.queuePop.bind(this.handler)}
        />
      );
    } else {
      studentButton = 'active';
      panel = (
        <StudentPanel
          segmentClass={segmentClass}
          requestHelp={this.handler.newRequest.bind(this.handler)}
          myRequest={this.getMyFirstRequest()}
        />
      );
    }

    if (this.props.instructor) {
      buttons = (
        <div className="ui two basic buttons">
          <div onClick={this.setMode.bind(this, true)} className={"ui button " + instructorButton}>Instructor Mode</div>
          <div onClick={this.setMode.bind(this, false)} className={"ui button " + studentButton}>Student Mode</div>
        </div>
      );
    }

    return (
      <div className={columnClass}>
        {buttons}
        {panel}
      </div>
    );
  },
  render: function () {
    var segmentClass = this.state.enabled ?
      'ui min segment' : 'ui disabled loading min segment';

    return (
      <div className="ui grid">
        {this.renderLeftPanel(segmentClass, "six wide column")}
        <div className="ten wide column">
          <RequestBox
            segmentClass={segmentClass}
            requests={this.state.requests}
            resolve={this.props.instructor ? this.handler.resolveRequest.bind(this.handler) : null}
          />
        </div>
      </div>
    );
  }
});
