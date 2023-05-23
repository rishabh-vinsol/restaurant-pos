function showPassword() {
  var password_field = document.getElementById("user_password");
 if (password_field.type === "password") {
   password_field.type = "text";
 } else {
   password_field.type = "password";
 }
};
