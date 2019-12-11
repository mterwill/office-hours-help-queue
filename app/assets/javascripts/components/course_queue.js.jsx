var CourseQueue = React.createClass({
  getInitialState: function () {
    return {
      enabled: false, // whether or not we're connecting or connected
      focused: true, // whether we're the currently active window
      instructorMode: this.props.instructor,
      requests: [],
      instructors: [],
      instructorMessage: '',
    };
  },
  updateTitle:function(){
    var myRequest = this.getMyFirstRequest();
    if (myRequest && this.state.requests.indexOf(myRequest.request) >= 0) {
      var myRequestIdx = this.state.requests.indexOf(myRequest.request);
      document.title = `(#${myRequestIdx + 1}) Office Hours Help Queue`
    } else {
      document.title = `(${this.state.requests.length}) Office Hours Help Queue`
    }
  },
  enable: function () {
    this.setState({ enabled: true });
  },
  amIOnline: function () {
    try {
      mapById(this.state.instructors, this.props.currentUserId);
      return true;
    } catch (e) {
      return false;
    }
  },
  disable: function () {
    this.setState({ enabled: false });
  },
  pushRequest: function (request) {
    this.setState({
      requests: this.state.requests.concat([request])
    }, function () {
      var wasEmpty         = this.state.requests.length === 1;
      var isInactiveWindow = this.state.focused === false;
      var isInstructor     = this.props.instructor;

      if (wasEmpty && isInactiveWindow && isInstructor) {
        this.notify('New request from ' + request.requester.name, false, {
          icon: request.requester.avatar_url,
          body: request.description || request.location,
        });
      }
    }.bind(this));
  },
  updateRequest: function (request) {
    var index   = mapById(this.state.requests, request.id);
    var arrCopy = copyArr(this.state.requests);

    arrCopy[index] = request;

    this.setState({
      requests: arrCopy,
    });
  },
  removeRequest: function (request) {
    var index = mapById(this.state.requests, request.id);
    var arrCopy = copyArr(this.state.requests);
    arrCopy.splice(index, 1);

    // are we up next?
    if (arrCopy.length > 0 && arrCopy[0].requester.id === this.props.currentUserId) {
      this.notify('You are next to be helped.');
    }

    this.setState({
      requests: arrCopy,
    });
  },
  pushInstructor: function (instructor) {
    this.setState({
      instructors: this.state.instructors.concat([instructor])
    });
  },
  updateInstructorMessage: function (message) {
    this.setState({
      instructorMessage: message,
    });
  },
  broadcastInstructorMessage: function (data) {
    if (this.props.currentUserId !== data.instructor.id){
      this.notify(data.instructor.name + ' announced to the queue:\n' + data.message, true,
                  {icon: data.instructor.avatar_url});
    }
  },
  removeInstructor: function (instructor) {
    var index = mapById(this.state.instructors, instructor.id);
    var arrCopy = copyArr(this.state.instructors);
    arrCopy.splice(index, 1);

    this.setState({
      instructors: arrCopy,
    });
  },
  fetchOutstandingRequests: function () {
    return $.ajax({
      url: '/course_queues/' + this.props.id + '/outstanding_requests.json'
    });
  },
  fetchOnlineInstructors: function () {
    return $.ajax({
      url: '/course_queues/' + this.props.id + '/online_instructors.json'
    });
  },
  fetchInstructorMessage: function () {
    return $.ajax({
      url: '/course_queues/' + this.props.id + '/instructor_message.json'
    });
  },
  notify: function (msg, force = false, options = {}) {
    if (!("Notification" in window)) {
      alert(msg); // fall back on alert
    } else if (force && Notification.permission !== "granted") {
      alert(msg); // sorry to be annoying
    } else if (Notification.permission === "granted") {
      var notification = new Notification(msg, options);
      notification.onclick = function (event) {
        // this should be the default behavior but click was doing nothing in
        // Chrome 56, so we'll just make it explicit.
        event.preventDefault();
        window.focus();
        notification.close();
      };
    } else {
      // leave the user in peace
    }
  },
  componentWillMount: function () {
    var courseQueueSubscription = App.cable.subscriptions.create({
      channel: 'QueueChannel',
      id: this.props.id
    }, {
      connected: function () {
        $.when(this.fetchOutstandingRequests(), this.fetchOnlineInstructors(), this.fetchInstructorMessage())
          .done(function (requests, instructors, message) {
            this.setState({
              instructors: instructors[0],
              requests: requests[0],
              instructorMessage: message[0].instructor_message,
            }, this.enable);
          }.bind(this));
      }.bind(this),
      disconnected: function () {
        this.disable();
      }.bind(this),
      received: function (data) {
        if (data.action === 'new_request') {
          this.pushRequest(data.request);
        } else if (data.action === 'update_request') {
          this.updateRequest(data.request);
        } else if (data.action === 'resolve_request') {
          this.removeRequest(data.request);
        } else if (data.action === 'instructor_offline') {
          this.removeInstructor(data.instructor);
        } else if (data.action === 'instructor_online') {
          this.pushInstructor(data.instructor);
        } else if (data.action === 'update_instructor_message'){
          this.updateInstructorMessage(data.message);
        } else if (data.action === 'broadcast_instructor_message'){
          this.broadcastInstructorMessage(data);
        } else if (data.action === 'bump'
                   && data.requester_id === this.props.currentUserId) {
           this.notify(data.bump_by.name + ' is looking for you!', true, {
             icon: data.bump_by.avatar_url,
           });
        } else if (data.action === 'invalid_request') {
          alert('Invalid request: ' + data.error);
        }
        this.updateTitle();
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
    var index = -1;
    if (this.props.groupMode) {
      index = this.state.requests.map(function (elt) {
        if (elt.course_group_id !== null) {
          return elt.course_group_id;
        } else {
          // don't count queue items without a group id
          return -1;
        }
      }).indexOf(this.props.courseGroupId);
    }

    if (index < 0) {
      // look for requests by our user if we didn't find one by the same group
      // or are not in group mode. the reason being if for some reason the group
      // id changes, we don't want the request to just get stranded.
      index = this.state.requests.map(function (elt) {
        return elt.requester_id;
      }).indexOf(this.props.currentUserId);
    }

    if (index >= 0) {
      return {
        request: this.state.requests[index],
        resolver: this.handler.resolveRequest.bind(this.handler, this.state.requests[index].id),
      }
    }

    return null;
  },
  componentDidMount: function () {
    this.addFocusListeners();
  },
  addFocusListeners: function () {
    // Set some state to keep track of if we're the currently active window

    window.addEventListener('blur', function () {
      this.setState({ focused: false });
    }.bind(this));

    window.addEventListener('focus', function () {
      this.setState({ focused: true });
    }.bind(this));
  },
  renderLeftPanel: function (columnClass) {
    var panel, instructorButton, studentButton, buttons;
 
    if (this.props.instructor && this.state.instructorMode) {
      instructorButton = 'active';
      panel = (
        <InstructorPanel
          segmentClass={this.getSegmentClass()}
          requests={this.state.requests}
          instructors={this.state.instructors}
          online={this.amIOnline()}
          currentUserId={this.props.currentUserId}
          queueLength={this.state.requests.length}
          queuePop={this.handler.queuePop.bind(this.handler)}
          emptyQueue={this.handler.emptyQueue.bind(this.handler)}
          setInstructorStatus={this.handler.setInstructorStatus.bind(this.handler)}
          takeQueueOffline={this.handler.takeQueueOffline.bind(this.handler)}
          pinTopRequest={this.pinTopRequest()}
        />
      );
    } else {
      studentButton = 'active';
      panel = (
        <StudentPanel
          segmentClass={this.getSegmentClass()}
          requestHelp={this.handler.newRequest.bind(this.handler)}
          cancelRequest={this.handler.cancelRequest.bind(this.handler)}
          updateRequest={this.handler.updateRequest.bind(this.handler)}
          myRequest={this.getMyFirstRequest()}
          queueClosed={!this.instructorsAvailable() || !this.userAuthorizedToEnqueue()}
          groupMode={this.props.groupMode}
        />
      );
    }

    if (this.props.instructor && this.state.enabled) {
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
  pinTopRequest: function () {
    // index = 0;
    // for(var r=0; r< this.state.requests.length; r++){
    //   if(!this.state.requests[r].resolver){
    //     index = r;
    //     break;
    //   }
    // }  
    // return (this.state.requests[index] != null ? this.handler.pin.bind(this.handler, this.state.requests[index]["id"]) :null)
    let unpinnedRequests = this.getUnpinnedRequests();
    return unpinnedRequests.length > 0 ? this.handler.pin.bind(this.handler, unpinnedRequests[0].id) : null;
  },
  getRequestsPinnedByMe: function () {
    return this.state.requests.filter(function (request) {
        return request.resolver_id === this.props.currentUserId;
    }.bind(this));
  },
  getRequestsPinnedByOthers: function () {
    return this.state.requests.filter(function (request) {
      return request.resolver_id !== null
        && request.resolver_id !== this.props.currentUserId;
    }.bind(this));
  },
  getUnpinnedRequests: function () {
    return this.state.requests.filter(function (request) {
        return request.resolver_id === null;
    }.bind(this));
  },
  getSegmentClass: function () {
    return this.state.enabled ?
      'ui min segment' : 'ui disabled loading min segment';
  },
  instructorsAvailable: function () {
    return this.state.instructors.length > 0;
  },
  userAuthorizedToEnqueue: function () {
    if (this.props.exclusiveMode) {
      return this.props.courseGroupId != null || this.props.instructor;
    } else {
      return true;
    }
  },
  renderRequestBox: function (title, requests, hideEmpty) {
    var myRequest = this.getMyFirstRequest();
    if (myRequest) {
      if (requests.indexOf(myRequest.request) >= 0) {
        var myRequestIdx = requests.indexOf(myRequest.request);
      }
    }

    return (
      <RequestBox
        title={title}
        hideEmpty={hideEmpty}
        segmentClass={this.getSegmentClass()}
        requests={requests}
        currentUserId={this.props.currentUserId}
        currentGroupId={this.props.groupMode ? this.props.courseGroupId : null}
        myRequestIdx={myRequestIdx}
        resolve={this.props.instructor ? this.handler.resolveRequest.bind(this.handler) : null}
        bump={this.props.instructor ? this.handler.bump.bind(this.handler) : null}
        pin={this.props.instructor ? this.handler.pin.bind(this.handler) : null}
      />
    );
  },
  render: function () {
    var pinnedByMeRequestBox = this.renderRequestBox(
      "Pinned By Me",
      this.getRequestsPinnedByMe(),
      true // hideEmpty
    );

    var pinnedByOthersRequestBox = this.renderRequestBox(
      this.props.instructor ? "Pinned By Others" : "Pinned By Instructors",
      this.getRequestsPinnedByOthers(),
      true // hideEmpty
    );

    var unpinnedRequestBox = this.renderRequestBox(
      "Requests",
      this.getUnpinnedRequests(),
      false // hideEmpty
    );

    return (
      <div className="ui stackable grid">
        <div className="sixteen wide column">
          <Header
            courseName={this.props.courseName}
            queueName={this.props.queueName}
            queueLoc={this.props.queueLoc}
          />
          <Instructors instructors={this.state.instructors} />
        </div>
        <QueueClosedMessage
          enabled={this.state.enabled}
          userAuthorizedToEnqueue={this.userAuthorizedToEnqueue()}
          instructorsAvailable={this.instructorsAvailable()} />
        <InstructorMessage
          enabled={this.state.enabled}
          instructors={this.state.instructors}
          instructorMode={this.state.instructorMode}
          instructorMessage={this.state.instructorMessage}
          updateInstructorMessage={this.handler.broadcastMessage.bind(this.handler)}
          broadcastInstructorMessage={this.handler.broadcastMessage.bind(this.handler)} />
        {this.renderLeftPanel("six wide column")}
        <div className="ten wide column">
          <NotificationsPanel instructorMode={this.state.instructorMode} />
          {pinnedByMeRequestBox}
          {unpinnedRequestBox}
          {pinnedByOthersRequestBox}
        </div>
      </div>
    );
  }
});
