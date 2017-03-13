var RequestCountLabel = React.createClass({
  render: function () {

    if (typeof this.props.myRequestIdx !== 'undefined') {
      var text = (this.props.myRequestIdx + 1) + '/' + this.props.total;
    } else {
      var text = this.props.total;
    }

    return (
      <div className="ui teal tiny horizontal label">
        {text}
      </div>
    );
  }
});
