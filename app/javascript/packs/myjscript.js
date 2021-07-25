
$(document).ready( function () {
    $(document).on('click', '.abc', function() {
        delete_file_element(this.id.toString())
    });

    setTimeout(function () {
            var bar = $('.bar');
            var percent = $('.percent');
            var status = $('#status');

            $('form').ajaxForm({
                beforeSend: function () {
                    status.empty();
                    var percentVal = '0%';
                    bar.width(percentVal);
                    percent.html(percentVal);
                },
                uploadProgress: function (event, position, total, percentComplete) {
                    var percentVal = percentComplete + '%';
                    bar.width(percentVal);
                    percent.html(percentVal);
                },
                complete: function (xhr) {
                    // status.html(xhr.responseText);
                }
            });

    }, 2500)
});

function delete_file_element(object_key) {
    $('#divLoading').css('display','block');
    $.ajax({
        method: "delete",
        contentType: "application/json",
        dataType: "json",
        url: "/upload_files/" + object_key.toString(),
        success: function success(response) {
            window.location.reload();
        },
        error: function success(response) {
            $('#divLoading').css('display','none');
            alert("ooops! something went wrong12.")
        }
    });
}

window.addEventListener('load', (event) => {
    $('input[type="file"]').change(function (event) {
        if (document.getElementById("upload_files").files.length > 0){
            var total_file = document.getElementById("upload_files").files.length;
        } else if (document.getElementById("upload_file").files.length > 0){
            var total_file = document.getElementById("upload_file").files.length;
        } else {
            var total_file = document.getElementById("upload_single").files.length;
        }
        $( "#image_preview" ).empty();
        for (var i = 0; i < total_file; i++) {
            if (event.target.files[i].type.indexOf("img") > 0 || event.target.files[i].type.indexOf("jpeg") > 0 || event.target.files[i].type.indexOf("png") > 0){
                $('#image_preview').append("<img src='" + URL.createObjectURL(event.target.files[i]) + "', class='img-thumbnail col-md-2 p-2 resize'>");
            }else if (event.target.files[i].type.indexOf("3gp") > 0 || event.target.files[i].type.indexOf("mp4") > 0 ){
                $('#image_preview').append("<video class='img-thumbnail col-md-2 p-2 resize'><source src='" + URL.createObjectURL(event.target.files[i]) + "'></video>");
            }else{
                $('#image_preview').append("<img src='/download.jpg', class='img-thumbnail col-md-2 p-2 resize'>");
            }
        }
    });
});

