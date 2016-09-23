var Avatar = React.createClass({
  render: function () {
    return (
      <a className="avatar">
        <img src={this.props.url} />
      </a>
    );
  }
});
