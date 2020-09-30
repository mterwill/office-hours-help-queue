var LabeledItem = React.createClass({
  render: function () {
    if (!this.props.children) {
      return false;
    }

    return (
      <div className="item">
        <i className={this.props.icon + ' icon'}></i>
        <div className="content">
          <div style={{ maxWidth: '50ch', textOverflow: 'ellipsis', overflow: 'hidden', whiteSpace: 'nowrap' }}>
            {this.props.children}
          </div>
        </div>
      </div >
    );
  }
});
