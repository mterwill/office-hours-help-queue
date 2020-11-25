var Action = React.createClass({
  render: function () {
    return (
      <span style={{ paddingRight: '4px' }}>
        <a className={this.props.data.className} onClick={this.props.data.action}>{this.props.data.title}</a>
      </span>
    );
  }
});
