var Ping = React.createClass({
    getInitialState: function () {
      return {
        pingMessage: "An instructor is looking for you!"
      };  
    },
    handleModalOpen: function () {
      $('.ui.modal')
        .modal({onHidden: this.resetMessage})
        .modal('show')
      ;
    },
    onMessageChange: function (e) {
      this.setState({
        pingMessage: e.target.value
      });
    },
    resetMessage: function() {
      this.setState({ pingMessage: "An instructor is looking for you!" });
    },
    sendMessage: function (e) {
      e.preventDefault()
      this.setState({ pingMessage: this.state.pingMessage.trim() }, function () {
        this.props.data.action(this.state.pingMessage);
      });
    },
    render: function () {
      modal = (
        <div className="ui modal">
          <i className="close icon"></i>
          <div className="header">Send a ping</div>
          <div className="content">
            <form className="ui form">
              <div className="field">
                <textarea onChange={this.onMessageChange} value={this.state.pingMessage}></textarea>
              </div>
            </form>
          </div>
          <div className="actions">
            <div className="ui approve button" onClick={this.sendMessage}>Send ping</div>
          </div>
        </div>
      );

      return (
        <span>
          <Action data={{ title: this.props.data.title, action: this.handleModalOpen }} />
          {modal}
        </span>
      );  
    }
});
