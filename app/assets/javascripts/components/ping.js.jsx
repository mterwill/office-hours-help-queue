var Ping = React.createClass({
    getInitialState: function () {
      return {
        pingMessage: this.props.pingMessage
      };  
    },
    handleOpen: function () {
      $('.ui.modal')
        .modal('show')
      ;
    },
    onChange: function (e) {
      this.setState({
        pingMessage: e.target.value
      });
    },
    updateMessage: function (e) {
      e.preventDefault()
      this.setState({ pingMessage: this.state.pingMessage.trim() }, function () {
        this.props.updatePingMessage('update_ping_message', this.state.pingMessage);
        this.props.data.action()
      });
    },
    componentDidUpdate: function (prevProps) {
      if (this.props.pingMessage !== prevProps.pingMessage) {
        this.setState({
          pingMessage: this.props.pingMessage
        });
      }
    },
    render: function () {
      modal = (
        <div className="ui modal">
          <i className="close icon"></i>
          <div className="header">Send a ping</div>
          <div className="content">
            <form className="ui form">
              <div className="field">
                <textarea onChange={this.onChange} value={this.state.pingMessage}></textarea>
              </div>
            </form>
          </div>
          <div className="actions">
            <div className="ui approve button" onClick={this.updateMessage}>Send ping</div>
          </div>
        </div>
      );

      return (
        <div>
          <a className={this.props.data.className} onClick={this.handleOpen}>{this.props.data.title}</a>
          {modal}
        </div>
      );  
    }
});
