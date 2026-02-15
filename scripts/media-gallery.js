// Lightweight Media Gallery and Slider Component
// Handles product image carousel/slider functionality

// Custom Element: slider-component
if (!customElements.get("slider-component")) {
  customElements.define(
    "slider-component",
    class SliderComponent extends HTMLElement {
      constructor() {
        super();
        this.slider = this.querySelector("ul");
        this.slides = this.querySelectorAll("li");
        this.currentIndex = 0;

        // Find next/prev buttons
        this.nextButton = this.querySelector(".slider-button--next");
        this.prevButton = this.querySelector(".slider-button--prev");

        if (this.nextButton) {
          this.nextButton.addEventListener("click", () => this.next());
        }
        if (this.prevButton) {
          this.prevButton.addEventListener("click", () => this.prev());
        }

        // Touch/swipe support
        this.setupTouchEvents();
      }

      next() {
        if (this.currentIndex < this.slides.length - 1) {
          this.currentIndex++;
          this.goToSlide(this.currentIndex);
        }
      }

      prev() {
        if (this.currentIndex > 0) {
          this.currentIndex--;
          this.goToSlide(this.currentIndex);
        }
      }

      goToSlide(index) {
        if (index < 0 || index >= this.slides.length) return;

        this.currentIndex = index;

        // Update active class
        this.slides.forEach((slide, i) => {
          if (i === index) {
            slide.classList.add("is-active");
          } else {
            slide.classList.remove("is-active");
          }
        });

        // Scroll to slide (for horizontal scrolling)
        if (this.slider && this.slides[index]) {
          const slideWidth = this.slides[index].offsetWidth;
          this.slider.scrollTo({
            left: slideWidth * index,
            behavior: "smooth",
          });
        }

        // Dispatch event for thumbnails
        this.dispatchEvent(
          new CustomEvent("slideChanged", {
            detail: { index: this.currentIndex },
            bubbles: true,
          }),
        );
      }

      setupTouchEvents() {
        let startX = 0;
        let currentX = 0;

        this.slider.addEventListener("touchstart", (e) => {
          startX = e.touches[0].clientX;
        });

        this.slider.addEventListener("touchmove", (e) => {
          currentX = e.touches[0].clientX;
        });

        this.slider.addEventListener("touchend", () => {
          const diff = startX - currentX;
          if (Math.abs(diff) > 50) {
            if (diff > 0) {
              this.next();
            } else {
              this.prev();
            }
          }
        });
      }
    },
  );
}

// Custom Element: media-gallery
if (!customElements.get("media-gallery")) {
  customElements.define(
    "media-gallery",
    class MediaGallery extends HTMLElement {
      constructor() {
        super();
        this.mainSlider = this.querySelector(
          "#GalleryViewer-" + this.dataset.section,
        );
        this.thumbnails = this.querySelector(
          "#GalleryThumbnails-" + this.dataset.section,
        );

        // Setup thumbnail clicks
        if (this.thumbnails) {
          const thumbButtons = this.thumbnails.querySelectorAll("button");
          thumbButtons.forEach((button, index) => {
            button.addEventListener("click", () => {
              if (this.mainSlider) {
                this.mainSlider.goToSlide(index);
              }
            });
          });

          // Listen for slide changes to update active thumbnail
          if (this.mainSlider) {
            this.mainSlider.addEventListener("slideChanged", (e) => {
              this.updateActiveThumbnail(e.detail.index);
            });
          }
        }
      }

      updateActiveThumbnail(index) {
        if (!this.thumbnails) return;

        const thumbButtons = this.thumbnails.querySelectorAll("button");
        thumbButtons.forEach((button, i) => {
          if (i === index) {
            button.setAttribute("aria-current", "true");
            button.classList.add("active");
          } else {
            button.removeAttribute("aria-current");
            button.classList.remove("active");
          }
        });
      }
    },
  );
}

// Initialize on page load
document.addEventListener("DOMContentLoaded", () => {
  // Set first slide as active if not already
  const sliders = document.querySelectorAll("slider-component");
  sliders.forEach((slider) => {
    const slides = slider.querySelectorAll("li");
    if (slides.length > 0 && !slider.querySelector("li.is-active")) {
      slides[0].classList.add("is-active");
    }
  });
});
