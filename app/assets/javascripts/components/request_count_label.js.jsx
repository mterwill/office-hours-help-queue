var RequestCountLabel = React.createClass({
  render: function () {
    return (
      <div className="ui teal tiny horizontal label">
        {this.props.count}
      </div>
    );
  }
});
