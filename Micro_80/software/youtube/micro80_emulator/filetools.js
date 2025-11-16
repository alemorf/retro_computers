// Micro 80 computer emulator from Radio magazine 1983
// (c) 25-05-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

function saveAs(data, filename) {
    var uri = "data:application/octet-stream;base64," + window.btoa(data);
    var link = document.createElement('a');
    if (typeof link.download === 'string') {
        link.href = uri;
        link.download = filename;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    } else {
        window.open(uri);
    }
}

function loadAs(result) {
    var link = document.createElement('div');
    link.innerHTML = '<input type="file">';
    var load = link.childNodes[0];
    document.body.appendChild(link);
    load.click();
    document.body.removeChild(link);
    load.onchange = function() {
        var fr = new FileReader;
        fr.readAsBinaryString(load.files[0]);
        fr.onload = function(event) {
            result(load.files[0].name, event.target.result);
        };
    }
}
