document.addEventListener("click", function (event) {
  if (event.target.matches(".remove_fields")) {
    var hiddenInput = event.target.previousElementSibling;
    hiddenInput.value = true;
    var fieldset = event.target.closest("fieldset");
    fieldset.style.display = "none";
    event.preventDefault();
  }
});

document.addEventListener("click", function (event) {
  var target = event.target;
  if (target.matches(".add_fields")) {
    var fieldsContainer = target;
    var time = new Date().getTime();
    var regexp = new RegExp(target.getAttribute("data-id"), "g");
    fieldsContainer.insertAdjacentHTML(
      "beforebegin",
      fieldsContainer.getAttribute("data-fields").replace(regexp, time)
    );
    event.preventDefault();
  }
});