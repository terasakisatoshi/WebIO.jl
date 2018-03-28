export iframe

function iframe(dom)
    str = stringmime("text/html", dom)
    
    s = Scope()
    s.dom = Node(:div,
                 Node(:iframe, id="ifr", style=Dict("width"=>"100%"),
                      attributes=Dict("src"=>"javascript:void()","frameborder"=>0, "scrolling"=>"no", "height"=>"100%")),
                style=Dict("overflow"=>"hidden"),
    )
    onimport(s,
        js"""function () {
            var frame = this.dom.querySelector("#ifr");
            var doc = frame.contentDocument
            var win = frame.contentWindow
            var webio = doc.createElement("script")
            webio.src = "/pkg/WebIO/webio/dist/bundle.js"
            var parent = window

            function resizeIframe() {
                doc.body.style.padding = '0'
                doc.body.style.margin = '0'
                doc.documentElement.height = '100%'
                doc.body.height = '100%'
                alert(doc.body.offsetHeight)
            }

            webio.onload = function () {
                win.WebIO.sendCallback = parent.WebIO.sendCallback; // Share stuff
                win.WebIO.scopes = parent.WebIO.scopes
                win.WebIO.obsscopes = parent.WebIO.obsscopes
                doc.body.innerHTML = "<html><body>" + $str + "</body></html>";
                setTimeout(function () { resizeIframe() }, 0)
            }

            doc.body.appendChild(webio)
        }""")
    s
end
