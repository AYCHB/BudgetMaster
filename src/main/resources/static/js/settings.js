$(document).ready(function()
{
    $('.modal').modal('open');

    $('#button-confirm-database-delete').click(function()
    {
        document.getElementById("form-confirm-database-delete").submit();
    });

    $('#button-confirm-database-import').click(function()
    {
        document.getElementById("form-database-import").submit();
    });

    $('input[name="autoBackupActivated"]').click(function()
    {
        $('#settings-auto-backup').toggle($(this).prop("checked"));
    });

    let autoBackupDays = $('#settings-backup-auto-days');
    if(autoBackupDays.length)
    {
        autoBackupDays.on('change keydown paste input', function()
        {
            validateNumber(autoBackupDays.val(), 'settings-backup-auto-days', "hidden-settings-backup-auto-days", numberValidationMessage);
        });
    }

    // on initial page load
    let autoBackupCheckbox = document.getElementsByName("autoBackupActivated")[0];
    $('#settings-auto-backup').toggle(autoBackupCheckbox.checked);
});

function validateForm()
{
    let autoBackupCheckbox = document.getElementsByName("autoBackupActivated")[0];
    if(autoBackupCheckbox.checked)
    {
        return validateNumber($('#settings-backup-auto-days').val(), 'settings-backup-auto-days', "hidden-settings-backup-auto-days", numberValidationMessage);
    }

    return true;
}