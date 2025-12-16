document.addEventListener("turbo:load", () => {
  const delivery = document.getElementById("deliverySelect");
  const postcode = document.getElementById("postcodeField");

  if (!delivery) return;

  const toggleFields = () => {
    if (delivery.value === "ukrposhta") {
      postcode.style.display = "block";
    } else {
      postcode.style.display = "none";
    }
  };

  delivery.addEventListener("change", toggleFields);
  toggleFields();
});