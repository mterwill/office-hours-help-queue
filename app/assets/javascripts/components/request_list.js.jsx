var RequestList = React.createClass({
  render: function () {
    var requestNodes = this.props.data.map(function (request) {
      return (
        <Request request={request} handler={this.props.handler} />
      );
    }.bind(this));

    return (
      <div className="ui comments">
        {requestNodes}
      </div>
    );
  }
});
