$(document).on('turbolinks:load', function () {
    $('#search-results-data-table').DataTable({
        responsive: true,
        language: {
            emptyTable: "There are no results to display.",
            searchPlaceholder: 'Search...',
            sSearch: '',
            lengthMenu: '_MENU_ items/page',
        }
    });

    $('.notification-link').click(function () {
        if (!$(this).hasClass('read')) {
            $.ajax({
                url: $(this).data('read-link'),
                method: 'PATCH'
            });
        }
    });

    if(document.getElementById('overdue-inspections-chart')) {
        $.getJSON('/cemeteries/api/overdue-inspections-by-region', function (data) {
            new Morris.Bar({
                // ID of the element in which to draw the chart.
                element: 'overdue-inspections-chart',
                // Chart data records -- each entry in this array corresponds to a point on
                // the chart.
                data: data,

                // The name of the data record attribute that contains x-values.
                xkey: 'region',
                // A list of names of data record attributes that contain y-values.
                ykeys: ['inspections'],
                // Labels for the ykeys -- will be displayed when you hover over the
                // chart.
                labels: ['Inspections']
            });
        });
    }
});