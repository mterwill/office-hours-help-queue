var Ping = React.createClass({
    getInitialState: function () {
      return {
        pingMessage: ""
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
                <textarea onChange={this.onChange}></textarea>
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
