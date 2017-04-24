var InstructorMessage = React.createClass({
  getInitialState: function () {
    return {
      editMode: false,
      instructorMessage: this.props.instructorMessage,
    };
  },
  buttonBaseClass: "ui fluid button ",
  update: function (event) {
    this.setState({
      instructorMessage: event.target.value,
    });
  },
  componentWillReceiveProps: function (nextProps) {
    // don't overwrite what we're editing
    if ((this.props.instructorMessage || nextProps.instructorMessage)
         && !this.state.editMode) {

      // empty the message if the queue closes
      if (this.props.instructors.length > 0 &&
          nextProps.instructors.length <= 0){

        this.setState({ instructorMessage: '' }, function (){
          this.updateMessage();
        });
      } else {
        this.setState({
          instructorMessage: nextProps.instructorMessage,
        });
      }
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
      <button type="button" onClick={this.broadcastConfirm} className={this.buttonBaseClass} tabIndex="0">
        <i className="send outline icon"></i>
        {this.state.editMode ? "Save and Broadcast" : "Broadcast"}
      </button>
    );
  },
  renderEditOrSaveBtn: function () {
    if (this.state.editMode){
      return (
        <button type="button" onClick={this.save} className={this.buttonBaseClass} tabIndex="0">
          <i className="save icon"></i>
            Save
        </button>
      );
    } else {
      return (
        <button type="button" onClick={this.updateEditMode.bind(this, true)} className={this.buttonBaseClass} tabIndex="0">
          <i className="edit icon"></i>
            Edit
        </button>
      );
    }
  },
  renderButtons: function () {
    return (
      <div className="ui stackable grid">
        <div className="ui six wide column">
          <div className="ui icon two buttons">
            {this.renderEditOrSaveBtn()}
            {this.renderBroadcastBtn()}
          </div>
        </div>
      </div>
    );
  },
  renderInstructorMode: function () {
    var isDisabled = true;
    if (this.state.editMode){
      isDisabled = false;
    }
    return (
      <div className="sixteen wide column">
        <div className="ui message">
          <div className="bottom padded header">Instructor's message</div>
          <div className="ui bottom padded fluid input">
            <input disabled={isDisabled} onChange={this.update} value={this.state.instructorMessage} type="text" maxLength="150" />
          </div>
          {this.renderButtons()}
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
    } else if (this.props.instructors.length > 0) {
      messageBar = this.renderStudentMode();
    }
    return messageBar;
  }
});
