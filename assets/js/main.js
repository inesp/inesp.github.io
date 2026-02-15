
/* This adds <div class="table-responsive">...</div> around every <table>
 * element. And we need this to be able to gracefully handle tables that
 * are too wide for the screen.
* */
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll("table").forEach(table => {
    if (!table.closest(".table-responsive")) {
      const wrapper = document.createElement("div");
      wrapper.className = "table-responsive";
      table.parentNode.insertBefore(wrapper, table);
      wrapper.appendChild(table);
    }
  });
});

/* Lightbox for images - click to view larger */
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll("article img").forEach(function (img) {
    img.style.cursor = "zoom-in";
    img.addEventListener("click", function () {
      var overlay = document.createElement("div");
      overlay.style.cssText =
        "position:fixed;inset:0;background:rgba(0,0,0,0.8);display:flex;align-items:center;justify-content:center;z-index:1000;cursor:zoom-out";
      overlay.innerHTML =
        '<img src="' + img.src + '" style="max-width:90%;max-height:90%">';
      var closeOverlay = function () {
        overlay.remove();
        document.removeEventListener("keydown", onEsc);
      };
      var onEsc = function (e) {
        if (e.key === "Escape") closeOverlay();
      };
      overlay.addEventListener("click", closeOverlay);
      document.addEventListener("keydown", onEsc);
      document.body.appendChild(overlay);
    });
  });
});
