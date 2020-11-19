var RequestBox = React.createClass({
  render: function () {
    if (this.props.hideEmpty && this.props.requests.length === 0) {
      return null;
    }

    return (
      <div className={this.props.segmentClass}>
        <h4 className="ui header">
          { this.props.title ? this.props.title : 'Queue' }
          <RequestCountLabel
            myRequestIdx={this.props.myRequestIdx}
            total={this.props.requests.length} />
        </h4>
        <RequestList
          requests={this.props.requests}
          currentUserId={this.props.currentUserId}
          currentGroupId={this.props.currentGroupId}
          resolve={this.props.resolve}
          pin={this.props.pin}
          bump={this.props.bump} 
          updatePingMessage={this.props.updatePingMessage}
        />
      </div>
    );
  }
});
