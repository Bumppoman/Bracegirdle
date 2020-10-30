/*document.addEventListener('turbolinks:load', () => {

  const overdueInspectionsChart = document.getElementById('overdue-inspections-chart');
  if(overdueInspectionsChart) {
    new Morris.Bar({

      // ID of the element in which to draw the chart.
      element: 'overdue-inspections-chart',

      // Chart data records -- each entry in this array corresponds to a point on
      // the chart.
      data: JSON.parse(overdueInspectionsChart.dataset.overdueInspectionsData),

      // The name of the data record attribute that contains x-values.
      xkey: 'region',

      // A list of names of data record attributes that contain y-values.
      ykeys: ['percentage'],

      // Labels for the ykeys -- will be displayed when you hover over the
      // chart.
      labels: ['Inspections'],

      ymax: 100,

      hoverCallback: (index, options, content, row) => {
        return 'Inspections: ' + row.inspections;
      }
    });
  }
});
*/