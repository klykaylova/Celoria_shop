document.addEventListener("turbo:load", () => {
  const thumbs = document.querySelectorAll(".product-thumbnails img");
  const mainImage = document.getElementById("mainImage");

  if (!thumbs.length || !mainImage) return;

  thumbs.forEach((thumb) => {
    thumb.addEventListener("click", () => {
      // змінюємо велике фото
      mainImage.src = thumb.src;

      // підсвічування активного превʼю
      document.querySelector(".product-thumbnails img.active")?.classList.remove("active");
      thumb.classList.add("active");
    });
  });
});