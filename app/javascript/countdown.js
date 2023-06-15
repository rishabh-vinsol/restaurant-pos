document.addEventListener("DOMContentLoaded", function () {
  var countdownElement = document.getElementById("countdown");
  var countdownValue = 5;

  var countdownInterval = setInterval(function () {
    countdownValue--;
    countdownElement.textContent = countdownValue;

    if (countdownValue === 0) {
      clearInterval(countdownInterval);
      window.location.href = 'http://localhost:3000/cart';
    }
  }, 1000);
});
