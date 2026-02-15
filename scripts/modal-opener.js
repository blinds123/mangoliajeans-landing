// Modal Opener Component
// Handles modal windows (size chart, terms, privacy policy, etc.)

// Custom Element: modal-dialog
if (!customElements.get("modal-dialog")) {
  customElements.define(
    "modal-dialog",
    class ModalDialog extends HTMLElement {
      constructor() {
        super();
        this.isOpen = false;

        // Find close button
        const closeButton = this.querySelector(".modal__close-button");
        if (closeButton) {
          closeButton.addEventListener("click", () => this.close());
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
        this.setAttribute("open", "");
        document.body.style.overflow = "hidden";
      }

      close() {
        this.isOpen = false;
        this.removeAttribute("open");
        document.body.style.overflow = "";
      }
    },
  );
}

// Initialize modal triggers
document.addEventListener("DOMContentLoaded", () => {
  // Size Chart modal
  const sizeChartButtons = document.querySelectorAll(
    '[data-open-modal="size-chart"]',
  );
  const sizeChartModal = document.querySelector("#modal-size-chart");

  sizeChartButtons.forEach((button) => {
    button.addEventListener("click", (e) => {
      e.preventDefault();
      if (sizeChartModal) {
        sizeChartModal.open();
      }
    });
  });

  // Generic modal openers
  document.querySelectorAll("[data-modal-opener]").forEach((opener) => {
    opener.addEventListener("click", (e) => {
      e.preventDefault();
      const modalId = opener.getAttribute("data-modal-opener");
      const modal = document.querySelector(`#${modalId}`);
      if (modal) {
        modal.open();
      }
    });
  });
});
