import consumer from "channels/consumer"

consumer.subscriptions.create("StockChannel", {
  connected() {
  },

  disconnected() {
  },

  received(data) {
    var container = document.getElementById('cart');
    var div = document.createElement('div');
    var elem = document.getElementById('meal_ids');
    var cart_meal_ids = elem.attributes['data-meal-ids'].value.slice(1,-1).split(', ');
    var cart_branch_id = elem.attributes['data-branch-id'].value

    if(!cart_meal_ids.includes(String(data.meal_id))) return;
    if(cart_branch_id !== String(data.branch_id)) return;

    div.classList += "alert alert-danger";
    div.innerHTML = `Item ${data.meal_name} is out of stock`;

    container.insertBefore(div, container.firstChild);
  }
});
