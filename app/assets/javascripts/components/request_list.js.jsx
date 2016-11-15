var RequestList = React.createClass({
  render: function () {
    var requestNodes = this.props.requests.map(function (request) {
      return (
        <Request 
          key={request.id}
          request={request}
          resolve={this.props.resolve}
        />
      );
    }.bind(this));

    return (
      <div className="ui comments">
        {requestNodes}
      </div>
    );
  }
});
