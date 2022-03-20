function specialistEmu()
{
    // Динамичкская подгрузка
    window.include = function(file)
    {
        var script = document.createElement('script');
        // script.onload = function() { ... }
        script.src = file;
        document.getElementsByTagName('head')[0].appendChild(script);
    }

    // Меню загрузки
    function makeLoadMenu()
    {
        var loadmenu = document.getElementById('loadMenu');
        var loadButton = document.getElementById('loadButton');

        loadButton.onclick = function()
        {
            loadmenu.style.display = "block";
        }

        function loadMenuClick(name)
        {
            loadmenu.style.display = "none";
            include("file_" + this.innerHTML + ".js");
        }

        var html = "Выберите файл для загрузки<br><br>";
        for(var i in fileList)
            html += "<div>" + fileList[i] + "</div>";
        loadmenu.innerHTML = html;

        for(var i in loadmenu.childNodes)
            loadmenu.childNodes[i].onclick = loadMenuClick;
    }
    makeLoadMenu();

    // Для отрисовки
    var canvas   = document.getElementById("specialistcanvas");

    // Все устройства компьютера
    var memory   = new Uint8Array(65536);
    var memory2  = new Uint8Array(65536);
    var keyboard = new SpecialistKeyboard();
    var video    = new SpecVideo(canvas, memory, memory2);
    var cpu      = new I8080();

    function reset()
    {
        for(var i in memory)
        {
            memory[i] = 0;
            memory2[i] = 0;
        }
        cpu.jump(0xC000);
    }

    document.getElementById('resetButton').onclick = reset;

    function loadFile(file)
    {
        var off = 0;
        if (file[0] == 0xE6) off++;
        var start = (file[off + 1] << 8) | file[off]; off += 2;
        var end   = (file[off + 1] << 8) | file[off]; off += 2;
        if(end < start) return;
        var size = end - start + 1;
        reset();
        for(var i=0; i<300000;)
            i += cpu.instruction();
        for (var i = 0; i < size; ++i)
            memory[start + i] = file[off + i];
        cpu.jump(start);
    }

    window.loadFile = loadFile;

    cpu.readMemory = function(addr)
    {
        if ((addr & 0xF800) == 0xF800) return keyboard.read(addr & 3);
        const romStart = 0xC000;
        if (addr >= romStart && addr - romStart < specialistRom.length) return specialistRom[addr - romStart];
        return memory[addr];
    }

    cpu.writeMemory = function(addr, byte)
    {
        if ((addr & 0xF800) == 0xF800) return keyboard.write(addr & 3, byte);
        memory2[addr] = keyboard.b[2];
        memory[addr] = byte;
    }

    var last_time = 0;
    const cpuSpeed = 2000000 / 1000;

    function cpuTick()
    {
        var now = new Date().getTime();
        var delta = now - last_time;
        if(delta > 500) delta = 500;
        last_time = now;

        for (var i = 0, is = delta * cpuSpeed; i < is;)
        {
            window._time = i / cpuSpeed / 1000;
            i += cpu.instruction();
        }
    }

    window.setInterval(cpuTick, 10);

    function videoTick() 
    {
        video.make();
    }

    window.setInterval(videoTick, 1000/50);
    reset();

    var fileInUrl = (document.URL+"").split("?");
    if(fileInUrl.length == 2) include("file_" + fileInUrl[1] + ".js");
}
