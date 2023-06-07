document.addEventListener("DOMContentLoaded", function () {
  var inventoryQuantity = document.querySelector("#inventory_quantity");
  var originalQuantity = parseInt(inventoryQuantity.dataset['originalQuantity']);
  var currentQuantity = parseInt(inventoryQuantity.value);
  

  show_comment(originalQuantity, currentQuantity);

  inventoryQuantity.addEventListener("input", function () {
    var currentQuantity = parseInt(this.value);
    show_comment(originalQuantity, currentQuantity)
  });
});

function show_comment(originalQuantity, currentQuantity){
  var commentField = document.querySelector("#comment_field");
  if (currentQuantity !== originalQuantity) {
    commentField.style.display = "block";
  } else {
    commentField.style.display = "none";
  }
}
