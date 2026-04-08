document.addEventListener("turbo:load", () => {

  // ===== ДОСТАВКА =====
  const delivery = document.getElementById("deliverySelect");
  const postcodeField = document.getElementById("postcodeField");

  if (delivery && postcodeField) {
    const toggleDelivery = () => {
      postcodeField.style.display =
        delivery.value === "ukrposhta" ? "block" : "none";
    };

    delivery.addEventListener("change", toggleDelivery);
    toggleDelivery();
  }

  // ===== ОПЛАТА =====
  const payment = document.getElementById("paymentSelect");
  const card = document.getElementById("cardFields");

  if (payment && card) {
    const togglePayment = () => {
      card.style.display = payment.value === "card" ? "block" : "none";
    };

    payment.addEventListener("change", togglePayment);
    togglePayment();
  }

  // ===== ТЕЛЕФОН =====
  const phone = document.getElementById("phoneInput");

  if (phone) {
    phone.addEventListener("input", function () {
      let numbers = this.value.replace(/\D/g, "");

      if (!numbers.startsWith("380")) numbers = "380";

      numbers = numbers.substring(0, 12);

      let formatted = "+380";
      if (numbers.length > 3) formatted += " " + numbers.substring(3, 5);
      if (numbers.length > 5) formatted += " " + numbers.substring(5, 8);
      if (numbers.length > 8) formatted += " " + numbers.substring(8, 10);
      if (numbers.length > 10) formatted += " " + numbers.substring(10, 12);

      this.value = formatted;
    });
  }

  // ===== КАРТА =====
  const cardNumber = document.getElementById("cardNumber");

  if (cardNumber) {
    cardNumber.addEventListener("input", function () {
      let value = this.value.replace(/\D/g, "").substring(0, 16);
      let formatted = value.match(/.{1,4}/g);
      this.value = formatted ? formatted.join(" ") : value;
    });
  }

  // ===== ДАТА =====
  const cardDate = document.getElementById("cardDate");

  if (cardDate) {
    cardDate.addEventListener("input", function () {
      let value = this.value.replace(/\D/g, "").substring(0, 4);

      this.value = value.length >= 3
        ? value.substring(0, 2) + "/" + value.substring(2)
        : value;
    });
  }

  // ===== CVV =====
  const cardCvv = document.getElementById("cardCvv");

  if (cardCvv) {
    cardCvv.addEventListener("input", function () {
      this.value = this.value.replace(/\D/g, "").substring(0, 3);
    });
  }

  // ===== 👁 TOGGLE =====
  document.querySelectorAll(".toggle-eye").forEach(icon => {
    icon.addEventListener("click", () => {
      const input = document.getElementById(icon.dataset.target);

      if (input.type === "password") {
        input.type = "text";
        icon.textContent = "🙈";
      } else {
        input.type = "password";
        icon.textContent = "👁";
      }
    });
  });

  // ===== 🔥 ВАЛІДАЦІЯ =====
  const form = document.getElementById("orderForm");

  if (form) {
    form.addEventListener("submit", function (e) {

      let hasError = false;

      // очистка
      document.querySelectorAll(".error-text").forEach(el => {
        el.textContent = "";
        el.style.display = "none";
      });

      document.querySelectorAll(".form-control").forEach(el => {
        el.classList.remove("input-error");
      });

      const showError = (input, message) => {
        const group = input.closest(".form-group");
        const error = group.querySelector(".error-text");

        if (error) {
          error.textContent = message;
          error.style.display = "block";
        }

        input.classList.add("input-error");
        hasError = true;
      };

      const firstName = document.querySelector("[name='order[first_name]']");
      const lastName = document.querySelector("[name='order[last_name]']");
      const address = document.querySelector("[name='order[address]']");
      const postcode = document.getElementById("postcodeInput");

      // ІМʼЯ
      if (!firstName.value.trim()) {
        showError(firstName, "Введіть ім'я");
      }

      // ПРІЗВИЩЕ
      if (!lastName.value.trim()) {
        showError(lastName, "Введіть прізвище");
      }

      // ТЕЛЕФОН
      if (!phone.value || phone.value.length < 17) {
        showError(phone, "Введіть коректний номер");
      }

      // АДРЕСА
      if (!address.value.trim()) {
        showError(address, "Введіть адресу");
      }

      // ІНДЕКС
      if (delivery.value === "ukrposhta" && !postcode.value.trim()) {
        showError(postcode, "Введіть індекс");
      }

      // КАРТА
      if (payment.value === "card") {
        const number = document.getElementById("cardNumber");
        const date = document.getElementById("cardDate");
        const cvv = document.getElementById("cardCvv");

        if (!number.value.replace(/\s/g, "")) {
          showError(number, "Введіть номер картки");
        }

        if (!date.value) {
          showError(date, "Введіть дату");
        }

        if (!cvv.value) {
          showError(cvv, "Введіть CVV");
        }
      }

      if (hasError) e.preventDefault();

    });
  }

});