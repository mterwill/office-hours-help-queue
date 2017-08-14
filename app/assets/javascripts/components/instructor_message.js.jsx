var InstructorMessage = React.createClass({
  getInitialState: function () {
    return {
      editMode: false,
      instructorMessage: this.props.instructorMessage,
    };
  },
  update: function (event) {
    this.setState({
      instructorMessage: event.target.value,
    });
  },
  // allows <a> elements with an href to be tab indexable and handle the onEnter
  // event by default
  NO_LINK: "#",
  componentWillReceiveProps: function (nextProps) {
    // don't overwrite what we're editing
    if ((this.props.instructorMessage || nextProps.instructorMessage)
         && !this.state.editMode) {

      this.setState({
        instructorMessage: nextProps.instructorMessage,
      });
    }
  },
  updateMessage: function () {
    this.setState({ instructorMessage: this.state.instructorMessage.trim() }, function () {
      this.props.updateInstructorMessage('update_instructor_message',
                                         this.state.instructorMessage);
    });
  },
  broadcastConfirm: function () {
    if (confirm("Broadcast:\n" + this.state.instructorMessage + "\nTo the entire queue?")){
      this.save()
      this.props.broadcastInstructorMessage('broadcast_instructor_message',
                                            this.state.instructorMessage);
    }
  },
  updateEditMode: function (state) {
    this.setState({
      editMode: state
    });
  },
  save: function (){
    this.updateEditMode(false);
    this.updateMessage();
  },
  renderBroadcastBtn: function () {
    return (
      <a onClick={this.broadcastConfirm} className="item" href={this.NO_LINK} role="button">
        Broadcast
      </a>
    );
  },
  renderEditOrSaveBtn: function () {
    if (this.state.editMode){
      return (
        <a onClick={this.save} className="item" href={this.NO_LINK} role="button">
          Save
        </a>
      );
    } else {
      return (
        <a onClick={this.updateEditMode.bind(this, true)} className="item" href={this.NO_LINK} role="button">
          Edit
        </a>
      );
    }
  },
  renderText: function () {
    if (this.state.editMode){
      return (
        <div className="ui form">
          <div className="field">
            <textarea rows="1" onChange={this.update} value={this.state.instructorMessage} type="text"></textarea>
          </div>
        </div>
      );
    } else {
      return (
        <div className="ui fluid ack-white-space">
          { this.state.instructorMessage ? this.state.instructorMessage : <i>No message yet</i> }
        </div>
      );
    }
  },
  renderBoldSectionOfHeader: function() {
    return (
      <div className="item">
        <div className="content">
          <div className="header">Instructor's message</div>
        </div>
      </div>
    );
  },
  renderHeader: function() {
    return (
      <div className="ui horizontal list">
        {this.renderBoldSectionOfHeader()}
        {this.renderEditOrSaveBtn()}
        {this.renderBroadcastBtn()}
      </div>
    );
  },
  renderInstructorMode: function () {
    return (
      <div className="sixteen wide column">
        <div className="ui message">
          {this.renderHeader()}
          {this.renderText()}
        </div>
      </div>
    );
  },
  renderStudentMode: function () {
    if (this.state.instructorMessage){
      var pluralLetter = this.props.instructors.length > 1 ? 's' : ''
      return (
        <div className="sixteen wide column">
          <Message
           title={"Message from the instructor" + pluralLetter}
           message={this.state.instructorMessage} />
        </div>
      );
    } else {
      return null;
    }
  },
  render: function () {
    if (!this.props.enabled){
      return null;
    }

    var messageBar = null;
    if (this.props.instructorMode){
      messageBar = this.renderInstructorMode();
    } else {
      messageBar = this.renderStudentMode();
    }
    return messageBar;
  }
});
