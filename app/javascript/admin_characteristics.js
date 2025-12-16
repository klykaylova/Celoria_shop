document.addEventListener("turbo:load", () => {
  const container = document.getElementById("characteristics-container");
  const addBtn = document.getElementById("add-char-btn");

  if (!container || !addBtn) return;

  // ➕ додати характеристику
  addBtn.addEventListener("click", () => {
    const row = document.createElement("div");
    row.classList.add("characteristic-row");
    row.style.display = "flex";
    row.style.gap = "10px";
    row.style.marginBottom = "10px";

    row.innerHTML = `
      <input type="text" name="product[characteristics_keys][]" 
             placeholder="Назва"
             class="form-control" style="width:40%">
      <input type="text" name="product[characteristics_values][]"
             placeholder="Значення"
             class="form-control" style="width:50%">
      <button type="button" class="remove-char" style="width:40px;">–</button>
    `;

    container.appendChild(row);
  });

  // ❌ видалити характеристику
  container.addEventListener("click", (e) => {
    if (e.target.classList.contains("remove-char")) {
      e.target.parentElement.remove();
    }
  });
});