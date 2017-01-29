var NotificationsPanel = React.createClass({
  requestNotifyPermission: function () {
    Notification.requestPermission().then(function (result) {
      if (result !== 'default') {
        // user approved or denied us, don't ask again
        document.cookie = "promptedForNotifications=true";
      }
    });
  },
  softDeny: function () {
    document.cookie = "promptedForNotifications=true";
    this.forceUpdate();
  },
  shouldPrompt: function () {
    var browserSupports = "Notification" in window;
    if (!browserSupports) {
      return false;
    }

    var hasSetPermission = Notification.permission !== "default";
    var hasSoftDenied    = document.cookie.replace(/(?:(?:^|.*;\s*)promptedForNotifications\s*\=\s*([^;]*).*$)|^.*$/, "$1") === "true";

    return !hasSetPermission && !hasSoftDenied;
  },
  render: function () {
    if (!this.shouldPrompt()) {
      // The user has already made a decision one way or another.
      return null;
    }

    if (this.props.instructorMode) {
      var message = (
        <p><strong>eecs.help</strong> can notify you when a request comes
          into an empty queue.</p>
      );
    } else {
      var message = (
        <p><strong>eecs.help</strong> can notify you when you're next on the
          queue.</p>
      );
    }

    return (
      <div className="ui message">
        <div className="ui right floated basic buttons">
          <div className="ui button" onClick={this.requestNotifyPermission}>
            Get notified
          </div>
          <div className="ui button" onClick={this.softDeny}>
            No thanks
          </div>
        </div>
        <div className="header">
          Notifications
        </div>
        {message}
      </div>
    );
  }
});
