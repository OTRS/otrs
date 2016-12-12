CKEDITOR.plugins.add('preventimagepaste', {
    init: function(editor) {

        function replaceImages(content) {
            if (!content) {
                return "";
            }
            return content.replace(/<img[^>]*src="data:image\/(bmp|dds|gif|jpg|jpeg|png|psd|pspimage|tga|thm|tif|tiff|yuv|ai|eps|ps|svg);base64,.*?"[^>]*>/gi, '');
        }

        // plugin reacts on pasting data and dropping data (drop also triggers paste)
        // this prevents paste of images (as base64-encoded data URIs), if the image plugin of CKEditor is not loaded
        // if the plugin is loaded all pasted/dropped images are handled with a correct upload
        editor.on('paste', function (event) {
            if (editor.readOnly) {
                return;
            }

            // if image plugin is active, we don't want to prevent pasting and dropping
            if (typeof editor.plugins.image2 !== 'undefined') {
                return;
            }

            // stop original paste event to edit pasted data first
            event.stop();
            if (event && event.data && event.data.dataValue) {
                editor.insertHtml(replaceImages(event.data.dataValue));
            }
        });
    }
});