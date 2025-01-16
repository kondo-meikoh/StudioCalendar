$(function () {
    $('#this_week').click(function () {
        location.href = 'index.aspx';
    });

    $('#prev_week').click(function () {
        var aw = $('#hdn_week').val();
        aw--;
        location.href = 'index.aspx?aw=' + aw;
    });

    $('#next_week').click(function () {
        var aw = $('#hdn_week').val();
        aw++;
        location.href = 'index.aspx?aw=' + aw;
    });

    $('#reload').click(function () {
        location.reload();
    });
});