var RequestList = React.createClass({
  render: function () {
    var requestNodes = this.props.requests.map(function (request) {
      return (
        <Request 
          key={request.id}
          request={request}
          resolve={this.props.resolve}
          bump={this.props.bump}
        />
      );
    }.bind(this));

    if (requestNodes.length <= 0) {
      requestNodes.push((
        <div key="smile" className="centered text">
          <i className="massive disabled smile icon"></i>
        </div>
      ));
    }

    return (
      <div className="ui comments">
        {requestNodes}
      </div>
    );
  }
});
