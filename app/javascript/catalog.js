document.addEventListener("turbo:load", () => {
  const sortSelect = document.getElementById("sortSelect");

  if (!sortSelect) return;

  sortSelect.addEventListener("change", () => {
    const selected = sortSelect.value;
    const url = new URL(window.location.href);

    url.searchParams.set("sort", selected);

    Turbo.visit(url.toString());
  });
});