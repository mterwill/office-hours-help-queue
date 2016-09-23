var Action = React.createClass({
  render: function () {
    return (
      <a onClick={this.props.onClick}>{this.props.title}</a>
    );
  }
});
