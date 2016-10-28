var RequestList = React.createClass({
  render: function () {
    var requestNodes = this.props.requests.map(function (request) {
      return (
        <Request 
          key={request.id}
          request={request}
          handler={this.props.handler}
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
