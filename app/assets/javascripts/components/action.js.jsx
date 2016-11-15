var Action = React.createClass({
  render: function () {
    return (
      <a className={this.props.data.className} onClick={this.props.data.action}>{this.props.data.title}</a>
    );
  }
});
