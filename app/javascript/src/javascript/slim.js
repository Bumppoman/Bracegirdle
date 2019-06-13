$(document).on('turbolinks:load', function () {

    $('.fc-datepicker').datepicker({});

    $('.select2-basic').select2({
        minimumResultsForSearch: Infinity,
        selectOnClose: true
    });

    $('.select2-show-search').select2({
        minimumResultsForSearch: '',
        selectOnClose: true
    });

    $('.dataTables_length select').select2({ minimumResultsForSearch: Infinity });

    $('.custom-file-input').change(function () {
        let file = $(this)[0].files[0].name;
        $(this).next('label').text(file);
    });

    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        $($.fn.dataTable.tables(true)).css('width', '100%');
        $($.fn.dataTable.tables(true)).DataTable().columns.adjust().draw();
    });

    $('.bracegirdle-redirect-action-button').click(function (event) {
        const success = $(this).data('success');
        $.ajax({
            url: $(this).data('path'),
            type: 'PATCH',
            success: function () {
                window.location.href = success;
            }
        });
    });
});

$(document).on('focus', '.select2-selection--single', function (e) {
    if (e.originalEvent) {
        let select2_open = $(this).parent().parent().siblings('select');
        select2_open.select2('open');
    }
});

$(document).on('select2:opening.disabled', ':disabled', function () {
    return false;
});

$.fn.steps.setStep = function (step) {
    var currentIndex = $(this).steps('getCurrentIndex');
    for(var i = 0; i < Math.abs(step - currentIndex); i++){
        if(step > currentIndex) {
            $(this).steps('next');
        }
        else{
            $(this).steps('previous');
        }
    }
};