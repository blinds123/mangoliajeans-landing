// Cart Drawer Component
// Handles shopping cart functionality and drawer open/close

// Custom Element: cart-drawer
if (!customElements.get("cart-drawer")) {
  customElements.define(
    "cart-drawer",
    class CartDrawer extends HTMLElement {
      constructor() {
        super();
        this.isOpen = false;

        // Find close button
        this.closeButton = this.querySelector(".drawer__close");
        if (this.closeButton) {
          this.closeButton.addEventListener("click", () => this.close());
        }

        // Close on overlay click
        this.addEventListener("click", (e) => {
          if (e.target === this) {
            this.close();
          }
        });

        // Close on ESC key
        document.addEventListener("keydown", (e) => {
          if (e.key === "Escape" && this.isOpen) {
            this.close();
          }
        });
      }

      open() {
        this.isOpen = true;
        this.classList.add("active");
        document.body.style.overflow = "hidden";
      }

      close() {
        this.isOpen = false;
        this.classList.remove("active");
        document.body.style.overflow = "";
      }

      updateQuantity(quantity) {
        const badge = document.querySelector(".cart-count-bubble");
        if (badge) {
          badge.textContent = quantity;
          badge.style.display = quantity > 0 ? "flex" : "none";
        }
      }
    },
  );
}

// Initialize cart drawer
document.addEventListener("DOMContentLoaded", () => {
  const cartDrawer = document.querySelector("cart-drawer");

  // Cart icon click to open drawer
  const cartIcon = document.querySelector(".header__icon--cart");
  if (cartIcon && cartDrawer) {
    cartIcon.addEventListener("click", (e) => {
      e.preventDefault();
      cartDrawer.open();
    });
  }
});
