var RequestBox = React.createClass({
  getInitialState: function() {
    return {
      requests: []
    };
  },
  render: function() {
    var disabled = this.state.enabled ? '' : 'disabled loading ';
    return (
      <div className={'ui ' + disabled + 'min segment'}>
        <h4 className="ui header">
          Queue
          <RequestCountLabel count={this.state.requests.length} />
        </h4>
        <RequestList data={this.state.requests} handler={this.handler} />
      </div>
    );
  }
});
