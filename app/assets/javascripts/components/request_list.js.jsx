var RequestList = React.createClass({
  render: () => {
    var requestNodes = this.props.data.map((request) => {
      return (
        <Request request={request} handler={this.props.handler} />
      );
    });

    return (
      <div className="ui comments">
        {requestNodes}
      </div>
    );
  }
});
