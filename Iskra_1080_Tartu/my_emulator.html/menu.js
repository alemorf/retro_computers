function makeMenu() {
    let visibleMenuItem = [];
    function parentOf(p, c) {
        while (p != null) {
            if (p == c)
                return true;
            p = p.parentNode;
        }
        return false;
    }
    function hideMenu() {
        for (let i in visibleMenuItem)
            visibleMenuItem[i].style.visibility = "hidden";
        visibleMenuItem = [];
        hideMenuTimer = 0;
    }
    function showMenu(obj) {
        let c = obj.querySelector("ul");
        if (!c)
            return false;
        let visibleMenuItem1 = [];
        var present = false;
        for (let i in visibleMenuItem) {
            if (visibleMenuItem[i] == c)
                present = true;
            ;
            if (!parentOf(obj, visibleMenuItem[i]) && !parentOf(visibleMenuItem[i], obj))
                visibleMenuItem[i].style.visibility = "hidden";
            else
                visibleMenuItem1.push(visibleMenuItem[i]);
        }
        visibleMenuItem = visibleMenuItem1;
        if (!present)
            visibleMenuItem.push(c);
        c.style.visibility = "visible";
        let rect = obj.getBoundingClientRect();
        if (obj.parentNode.classList.contains("menu")) {
            c.style.top = (rect.bottom + document.body.scrollTop) + "px";
            c.style.left = (rect.left + document.body.scrollLeft) + "px";
        } else {
            let prect = obj.parentNode.getBoundingClientRect();
            c.style.top = (rect.top - prect.top + document.body.scrollTop - 4) + "px";
            c.style.left = (rect.right - prect.left + document.body.scrollLeft) + "px";
        }
        return true;
    }
    let hideMenuTimer = 0;
    let a = document.querySelectorAll(".menu li");
    for (let i = 0; i < a.length; i++) {
        if (a[i].parentNode.className != "menu" && a[i].querySelectorAll("ul").length > 0)
            a[i].firstChild.classList.add("sub");
    
        a[i].onmouseout = function(e) {
            if (hideMenuTimer)
                clearTimeout(hideMenuTimer);
            hideMenuTimer = setTimeout(hideMenu, 1000);
            e.stopPropagation();
        };
        a[i].onmouseover = function(e) {
            if (visibleMenuItem.length > 0)
                showMenu(this);
            if (hideMenuTimer) {
                clearTimeout(hideMenuTimer);
                hideMenuTimer = 0;
            }
            e.stopPropagation();
        };
        a[i].addEventListener("click", function(e) {
            if (!showMenu(this))
                hideMenu();
            if (this.onclick1)
                this.onclick1();
            e.stopPropagation();
        });
    }
}
