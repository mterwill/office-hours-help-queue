var LabeledItem = React.createClass({
  render: function () {
    if (this.props.children == false) {
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
