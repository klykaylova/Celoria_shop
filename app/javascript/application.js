import "@hotwired/turbo-rails"

import "controllers"
import "products_gallery"
import "catalog"
import "order_form"
import "admin_characteristics"

// -------------------------------
// 🔥 АВТОЗНИКНЕННЯ ФЛЕШ-ПОВІДОМЛЕНЬ
// -------------------------------
function initFlashFade() {
  const flashes = document.querySelectorAll(".flash-message");
  if (flashes.length === 0) return;

  flashes.forEach((flash) => {
    setTimeout(() => {
      flash.style.transition = "opacity 0.5s ease";
      flash.style.opacity = "0";

      setTimeout(() => flash.remove(), 6000);
    }, 2000); // ⏳ висить 2 сек
  });
}

// Запуск для Turbo
document.addEventListener("turbo:load", initFlashFade);

// Запуск для звичайного DOM
document.addEventListener("DOMContentLoaded", initFlashFade);


// -------------------------------

document.addEventListener("DOMContentLoaded", () => {
  const deliverySelect = document.getElementById("order_delivery_method");
  const addressField = document.getElementById("delivery-address");

  if (deliverySelect && addressField) {
    deliverySelect.addEventListener("change", () => {
      if (deliverySelect.value === "nova_poshta" || deliverySelect.value === "ukrposhta") {
        addressField.style.display = "block";
      } else {
        addressField.style.display = "none";
      }
    });
  }
});

