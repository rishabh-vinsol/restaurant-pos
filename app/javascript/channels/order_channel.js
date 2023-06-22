import consumer from "channels/consumer";

consumer.subscriptions.create("OrderChannel", {
  connected() {
  },

  disconnected() {
  },

  received(data) {
    var table = document.getElementById("orders_table");
    var tr = document.createElement("tr");
    var line_items_text = "";
    data.line_items.forEach((line_item) => {
      line_items_text += `
        <tr>
          <td width=80%>${line_item.name}</td>
          <td>${line_item.quantity}</td>
          <td></td>
        </tr>
      `;
    });

    tr.innerHTML = `
      <td>${data.id}</td>
      <td>${data.customer_name}</td>
      <td colspan=2>
        <table class="table table-borderless table-hover table-sm mb-0">
          <tbody>
          ${line_items_text}
          </tbody>
        </table>
      </td>
      <td>Rs. ${data.total}</td>
      <td>${data.date}</td>
      <td>${data.pickup_time}</td>
      <td>${data.picked_up_at || ''}</td>
      <td>${data.status}</td>
      <td>
        <div class="d-flex">
          <a class="btn btn-primary btn-sm me-2" rel="nofollow" data-method="post" href="/branches/${data.branch_url_slug}/order_ready?order_id=${data.id}">Mark as Ready</a>
        </div>
      </td>
      <td>
        <a class="btn btn-danger btn-sm me-2" rel="nofollow" data-method="post" href="/branches/${data.branch_url_slug}/order_cancelled?order_id=${data.id}">Cancel Order</a>
      </td>
    `;
    table.insertBefore(tr, table.firstChild);
  },
});
