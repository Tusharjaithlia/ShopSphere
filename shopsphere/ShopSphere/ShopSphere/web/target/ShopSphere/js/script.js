// ==========================================================================
// ShopSphere E-Commerce - Main Client JavaScript
// ==========================================================================

document.addEventListener("DOMContentLoaded", function () {

    // 1. Confirmation handlers on forms (e.g. data-confirm="Are you sure?")
    const confirmationForms = document.querySelectorAll("form[data-confirm]");
    confirmationForms.forEach(function (form) {
        form.addEventListener("submit", function (event) {
            const message = form.getAttribute("data-confirm");
            if (message && !window.confirm(message)) {
                event.preventDefault();
            }
        });
    });

    // 2. Quantity input bounds enforcement
    const qtyInputs = document.querySelectorAll('input[type="number"][name="quantity"]');
    qtyInputs.forEach(function (input) {
        input.addEventListener("change", function () {
            const min = parseInt(input.getAttribute("min")) || 1;
            const max = parseInt(input.getAttribute("max")) || 999;
            let val = parseInt(input.value) || min;
            if (val < min) val = min;
            if (val > max) val = max;
            input.value = val;
        });
    });

    // 3. Checkout Address toggle validation
    const checkoutForm = document.getElementById("checkoutForm");
    if (checkoutForm) {
        checkoutForm.addEventListener("submit", function (e) {
            const savedRadio = document.querySelector('input[name="addressId"]:checked');
            const customAddr = document.getElementById("address");

            if (!savedRadio && (!customAddr || customAddr.value.trim() === "")) {
                e.preventDefault();
                alert("Please select a saved address or enter a delivery address.");
                if (customAddr) customAddr.focus();
            }
        });
    }

    // 4. Auto dismiss alerts after 5 seconds if desired
    const alerts = document.querySelectorAll(".alert-success, .alert-info");
    alerts.forEach(function (alertBox) {
        setTimeout(function () {
            alertBox.style.transition = "opacity 0.5s ease";
            alertBox.style.opacity = "0.9";
        }, 5000);
    });

    console.log("ShopSphere Client UI loaded successfully.");
});