var Message = React.createClass({
  render: function () {
    return (
      <div className="ui message">
          <div className="header">{this.props.title}</div>
          <p className="ack-white-space">{this.props.message}</p>
      </div>
    );
  }
});
