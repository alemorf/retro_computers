// Micro 80 computer emulator from Radio magazine 1983
// (c) 25-05-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

function Micro80ScreenKeyboard(parentDocumentElement) {
    let html = '<link href="micro80screenkeyboard.css" rel="stylesheet" type="text/css">';
    html += '<div style="left:0px;top:0px" id="key12">;<br>+</div>';
    html += '<div style="left:50px;top:0px" id="key1">1<br>!</div>';
    html += '<div style="left:100px;top:0px" id="key2">2<br>"</div>';
    html += '<div style="left:150px;top:0px" id="key3">3<br>#</div>';
    html += '<div style="left:200px;top:0px" id="key4">4<br>$</div>';
    html += '<div style="left:250px;top:0px" id="key5">5<br>%</div>';
    html += '<div style="left:300px;top:0px" id="key6">6<br>&</div>';
    html += '<div style="left:350px;top:0px" id="key8">7<br>\'</div>';
    html += '<div style="left:400px;top:0px" id="key9">8<br>(</div>';
    html += '<div style="left:450px;top:0px" id="key10">9<br>)</div>';
    html += '<div style="left:500px;top:0px" id="key0">0<br>&nbsp;</div>';
    html += '<div style="left:550px;top:0px" id="key14">-<br>=</div>';
    html += '<div style="left:600px;top:0px" id="key64">ЗБ</div>';
    html += '<div style="left:750px;top:0px" id="key62">ESC<br><span>F3</span></div>';
    html += '<div style="left:800px;top:0px" id="key61">РУС<br><span>F2</span></div>';
    html += '<div style="left:25px;top:50px" id="key29">Й<br>J</div>';
    html += '<div style="left:75px;top:50px" id="key21">Ц<br>C</div>';
    html += '<div style="left:125px;top:50px" id="key42">У<br>U</div>';
    html += '<div style="left:175px;top:50px" id="key30">К<br>K</div>';
    html += '<div style="left:225px;top:50px" id="key24">Е<br>E</div>';
    html += '<div style="left:275px;top:50px" id="key34">Н<br>N</div>';
    html += '<div style="left:325px;top:50px" id="key26">Г<br>G</div>';
    html += '<div style="left:375px;top:50px" id="key49">Ш<br>[</div>';
    html += '<div style="left:425px;top:50px" id="key51">Щ<br>]</div>';
    html += '<div style="left:475px;top:50px" id="key48">З<br>Z</div>';
    html += '<div style="left:525px;top:50px" id="key27">Х<br>H</div>';
    html += '<div style="left:575px;top:50px" id="key11">:<br>*</div>';
    html += '<div style="left:625px;top:50px" id="key60">ВК<br><span>Enter</span></div>';
    html += '<div style="left:0px;top:100px" id="key65">УС<br><span>F1</span></div>';
    html += '<div style="left:50px;top:100px" id="key25">Ф<br>F</div>';
    html += '<div style="left:100px;top:100px" id="key46">Ы<br>Y</div>';
    html += '<div style="left:150px;top:100px" id="key44">В<br>W</div>';
    html += '<div style="left:200px;top:100px" id="key19">А<br>A</div>';
    html += '<div style="left:250px;top:100px" id="key36">П<br>P</div>';
    html += '<div style="left:300px;top:100px" id="key38">Р<br>R</div>';
    html += '<div style="left:350px;top:100px" id="key35">О<br>O</div>';
    html += '<div style="left:400px;top:100px" id="key32">Л<br>L</div>';
    html += '<div style="left:450px;top:100px" id="key22">Д<br>D</div>';
    html += '<div style="left:500px;top:100px" id="key43">Ж<br>V</div>';
    html += '<div style="left:550px;top:100px" id="key50">Э<br>\</div>';
    html += '<div style="left:600px;top:100px" id="key16">.<br>></div>';
    html += '<div style="left:750px;top:100px" id="key58">↑</div>';
    html += '<div style="left:25px;top:150px" id="key66">СС<br><span>Shift</span></div>';
    html += '<div style="left:75px;top:150px" id="key37">Я<br>Q</div>';
    html += '<div style="left:125px;top:150px" id="key52">Ч<br>^</div>';
    html += '<div style="left:175px;top:150px" id="key21">С<br>S</div>';
    html += '<div style="left:225px;top:150px" id="key33">М<br>M</div>';
    html += '<div style="left:275px;top:150px" id="key28">И<br>I</div>';
    html += '<div style="left:325px;top:150px" id="key41">Т<br>T</div>';
    html += '<div style="left:375px;top:150px" id="key45">Ь<br>X</div>';
    html += '<div style="left:425px;top:150px" id="key20">Б<br>B</div>';
    html += '<div style="left:475px;top:150px" id="key18">Ю<br>@</div>';
    html += '<div style="left:525px;top:150px" id="key13">,<br>&lt;</div>';
    html += '<div style="left:575px;top:150px" id="key17">/<br>?</div>';
    html += '<div style="left:700px;top:150px" id="key57">←</div>';
    html += '<div style="left:750px;top:150px" id="key59">↓</div>';
    html += '<div style="left:800px;top:150px" id="key56">→</div>';
    html += '<div style="left:125px;top:200px;width:395px" id="key54"> </div>';

    let div = document.createElement('div');
    div.className = "keyboard";
    div.innerHTML = html;
    (parentDocumentElement ? parentDocumentElement : document.body).appendChild(div);

    let uiObjects = [];
    let keyHandler = null;
    let touchmode = false;

    function callKeyHandler(keyCode, press) {
        if (keyHandler)
            keyHandler(keyCode, press);
    }

    for (let i = 0; i < 73; i++) {
        let o = div.querySelector("#key" + i);
        if (o) {
            uiObjects[i] = o;
            let ii = i;
            o.addEventListener('touchstart', function(e) {
                touchmode = true;
                callKeyHandler(ii, true);
            });
            o.addEventListener('touchend', function(e) {
                callKeyHandler(ii, false);
            });
            o.addEventListener('pointerdown', function(e) {
                if (!touchmode) {
                    this.setPointerCapture(e.pointerId);
                    callKeyHandler(ii, true);
                }
            });
            o.addEventListener('pointerup', function(e) {
                if (!touchmode) {
                    this.releasePointerCapture(e.pointerId);
                    callKeyHandler(ii, false);
                }
            });
        }
    }

    this.setKeyHandler = function(handler) {
        keyHandler = handler;
    };

    this.keyPressed = function(index, pressed) {
        let key = uiObjects[index];
        if (key) {
            if (pressed)
                key.classList.add("p");
            else
                key.classList.remove("p");
        }
    };
}
