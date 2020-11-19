var Action = React.createClass({
  render: function () {
    if (this.props.data.title === 'Ping') {
      action = <Ping data={this.props.data} updatePingMessage={this.props.updatePingMessage} />
    }
    else {
      action = <a className={this.props.data.className} onClick={this.props.data.action}>{this.props.data.title}</a>
    }
    return (
      <div>
        {action}
      </div>
    );
  }
});
