//= require rails-ujs
document.addEventListener("DOMContentLoaded", function () {
  document.addEventListener("click", function (event) {
    if (event.target.classList.contains("add-to-cart-btn")) {
      event.preventDefault();

      var button = event.target;
      var mealId = button.getAttribute("data-meal-id");

      Rails.ajax({
        url: "/add_to_cart",
        type: "POST",
        data: "meal_id=" + encodeURIComponent(mealId),
        success: function (response) {
          var cartCount = response.cart_count;
          var cartCountElement = document.getElementById("cart-count");
          var cartElement = document.getElementById("cart-button");
          var divMessage = document.getElementById("cart-notice");
          cartCountElement.innerText = cartCount;
          cartCountElement.classList.add("blink");
          cartElement.classList.add("cart-blink");
          divMessage.innerHTML = "Item added to cart!";
          divMessage.style.display = "block";

          setTimeout(function () {
            cartCountElement.classList.remove("blink");
            cartElement.classList.remove("cart-blink");
          }, 1000);
        },
        error: function (xhr) {
          if (xhr.status === 401) {
            var loginUrl = xhr.login_url;
            alert("Please log in to perform this action.");
            window.location.href = loginUrl;
          } else if (xhr.status === 422) {
            alert(xhr.errors);
          }
        },
      });
    }
  });
});
