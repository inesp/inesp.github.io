
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
