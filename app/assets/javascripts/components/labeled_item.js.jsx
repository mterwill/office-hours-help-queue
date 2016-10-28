var LabeledItem = React.createClass({
  render: function () {
    if (this.props.children == null) {
      return false;
    }

    return (
      <div className="item">
        <i className={this.props.icon + ' icon'}></i>
        <div className="content">
          {this.props.children}
        </div>
      </div>
    );
  }
});
