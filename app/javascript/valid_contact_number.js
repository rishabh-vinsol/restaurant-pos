function validateContactNumber() {
  const quantityInput = document.getElementById("order_contact_number");
  const quantityValue = parseInt(quantityInput.value);

  if (quantityValue > 9999999999 || quantityValue < 1000000000 || quantityInput.value == '') {
    quantityInput.setCustomValidity("Please enter a valid contact number");
  } else {
    quantityInput.setCustomValidity("");
  }
}
