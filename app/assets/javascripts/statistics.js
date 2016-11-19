$(document).ready(function () {
  $.get(window.location.href + '.json', function (rawData) {
    var resolvedByDayData = {
      labels: rawData.resolved_by_day.map(function (e) { return moment(e[0]).format('ddd, MMM D YYYY') }),
      datasets: [{
        label: rawData.course_name,
        fill: false,
        lineTension: 0.1,
        backgroundColor: "rgba(75,192,192,0.4)",
        borderColor: "rgba(75,192,192,1)",
        borderCapStyle: 'butt',
        borderDash: [],
        borderDashOffset: 0.0,
        borderJoinStyle: 'miter',
        pointBorderColor: "rgba(75,192,192,1)",
        pointBackgroundColor: "#fff",
        pointBorderWidth: 1,
        pointHoverRadius: 5,
        pointHoverBackgroundColor: "rgba(75,192,192,1)",
        pointHoverBorderColor: "rgba(220,220,220,1)",
        pointHoverBorderWidth: 2,
        pointRadius: 1,
        pointHitRadius: 10,
        data: rawData.resolved_by_day.map(function (e) { return e[1] }),
        spanGaps: false,
      }]
    };

    var colors = randomColor({
      seed: rawData.course_name,
      count: rawData.staff_contributions.length,
    });

    var staffContributionsData = {
      labels: rawData.staff_contributions.map(function (e) { return e[0] }),
      datasets: [
        {
          data: rawData.staff_contributions.map(function (e) { return e[2] }),
          backgroundColor: colors,
          hoverBackgroundColor: colors,
        }]
    };

    var resolvedByDayChart = new Chart($('#resolved-by-day'), {
      type: 'line',
      data: resolvedByDayData,
      options: {
        title: {
          display: true,
          text: 'Requests By Day'
        },
        legend: {
          display: false,
        },
        scales: {
          xAxes: [{
            display: false,
          }]
        },
      }
    });

    var staffContributionsChart = new Chart($('#staff-contributions'), {
      type: 'doughnut',
      data: staffContributionsData,
      options: {
        title: {
          display: true,
          text: 'Staff Contributions'
        },
        legend: {
          display: false,
        },
      }
    });
  });
});
