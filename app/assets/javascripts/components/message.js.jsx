var Message = React.createClass({
  render: function () {
    return (
      <div className="ui message">
          <div className="header">{this.props.title}</div>
          <p>{this.props.message}</p>
      </div>
    );
  }
});
