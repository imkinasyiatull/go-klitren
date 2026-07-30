(() => {
  "use strict";

  const script =
    document.currentScript ||
    document.querySelector('script[src$="assets/js/site.js"]');

  if (!script) return;

  const siteRoot = new URL("../../", script.src);
  const pageUrl = (path) => new URL(path, siteRoot).href;

  const mainNavigation = [
    { label: "Beranda", path: "index.html" },
    { label: "RW 13", path: "pages/rw-13.html" },
    { label: "RW 16", path: "pages/rw-16.html" },
    { label: "Program dan Materi", path: "pages/programs.html" },
  ];

  const styles = document.createElement("style");
  styles.textContent = `
    .go-mobile-nav {
      position: fixed;
      top: 4.75rem;
      right: 1rem;
      z-index: 1000;
      width: min(20rem, calc(100vw - 2rem));
      padding: .75rem;
      border: 1px solid #bdcac0;
      border-radius: 1rem;
      background: #fff;
      box-shadow: 0 12px 35px rgba(23, 29, 25, .18);
    }

    .go-mobile-nav[hidden] {
      display: none;
    }

    .go-mobile-nav a {
      display: block;
      padding: .8rem 1rem;
      border-radius: .65rem;
      color: #171d19;
      font: 600 14px/20px Inter, sans-serif;
      text-decoration: none;
    }

    .go-mobile-nav a:hover,
    .go-mobile-nav a:focus-visible {
      color: #fff;
      background: #006c46;
      outline: none;
    }

    .go-toast {
      position: fixed;
      left: 50%;
      bottom: 1.5rem;
      z-index: 1100;
      max-width: min(32rem, calc(100vw - 2rem));
      padding: .8rem 1rem;
      border-radius: .75rem;
      color: #fff;
      background: #2c322e;
      box-shadow: 0 8px 30px rgba(23, 29, 25, .22);
      font: 500 14px/20px Inter, sans-serif;
      opacity: 0;
      transform: translate(-50%, .75rem);
      pointer-events: none;
      transition: opacity .2s ease, transform .2s ease;
    }

    .go-toast[data-visible="true"] {
      opacity: 1;
      transform: translate(-50%, 0);
    }

    [data-placeholder-link="true"] {
      cursor: not-allowed;
    }

    .go-menu-fallback {
      position: fixed;
      right: 1rem;
      bottom: 1rem;
      z-index: 1001;
      display: inline-grid;
      width: 3.25rem;
      height: 3.25rem;
      place-items: center;
      border: 0;
      border-radius: 999px;
      color: #fff;
      background: #006c46;
      box-shadow: 0 8px 24px rgba(0, 108, 70, .28);
      cursor: pointer;
    }

    @media (min-width: 768px) {
      .go-mobile-nav,
      .go-menu-fallback {
        display: none;
      }
    }
  `;
  document.head.append(styles);

  let toastTimer;
  const toast = document.createElement("div");
  toast.className = "go-toast";
  toast.setAttribute("role", "status");
  toast.setAttribute("aria-live", "polite");
  document.body.append(toast);

  function showToast(message) {
    window.clearTimeout(toastTimer);
    toast.textContent = message;
    toast.dataset.visible = "true";
    toastTimer = window.setTimeout(() => {
      toast.dataset.visible = "false";
    }, 3200);
  }

  const menuButtons = [...document.querySelectorAll("button")].filter((button) => {
    const label = button.getAttribute("aria-label") || "";
    const text = button.textContent.trim();
    return /menu/i.test(label) || text === "menu";
  });

  if (menuButtons.length === 0) {
    const fallbackMenuButton = document.createElement("button");
    fallbackMenuButton.className = "go-menu-fallback";
    fallbackMenuButton.setAttribute("aria-label", "Menu");
    fallbackMenuButton.innerHTML =
      '<span class="material-symbols-outlined" aria-hidden="true">menu</span>';
    document.body.append(fallbackMenuButton);
    menuButtons.push(fallbackMenuButton);
  }

  menuButtons.forEach((button, index) => {
    const panel = document.createElement("nav");
    const panelId = `go-mobile-nav-${index + 1}`;

    panel.id = panelId;
    panel.className = "go-mobile-nav";
    panel.setAttribute("aria-label", "Navigasi seluler");
    panel.hidden = true;
    panel.innerHTML = mainNavigation
      .map(
        ({ label, path }) =>
          `<a href="${pageUrl(path)}">${label}</a>`,
      )
      .join("");

    document.body.append(panel);
    button.type = "button";
    button.setAttribute("aria-controls", panelId);
    button.setAttribute("aria-expanded", "false");

    const closeMenu = () => {
      panel.hidden = true;
      button.setAttribute("aria-expanded", "false");
    };

    button.addEventListener("click", (event) => {
      event.stopPropagation();
      const shouldOpen = panel.hidden;

      document.querySelectorAll(".go-mobile-nav").forEach((otherPanel) => {
        otherPanel.hidden = true;
      });
      menuButtons.forEach((otherButton) => {
        otherButton.setAttribute("aria-expanded", "false");
      });

      panel.hidden = !shouldOpen;
      button.setAttribute("aria-expanded", String(shouldOpen));
    });

    panel.addEventListener("click", (event) => event.stopPropagation());
    document.addEventListener("click", closeMenu);
    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape") closeMenu();
    });
  });

  document.querySelectorAll("a").forEach((anchor) => {
    const href = (anchor.getAttribute("href") || "").trim();
    const isPlaceholder = href === "#" || /^\[LINK_[A-Z0-9_]+\]$/.test(href);

    if (!isPlaceholder) return;

    anchor.dataset.placeholderLink = "true";
    anchor.setAttribute("aria-disabled", "true");
    anchor.addEventListener("click", (event) => {
      event.preventDefault();
      showToast("Tautan ini belum tersedia. Tambahkan URL tujuan saat materinya siap.");
    });
  });

  document.querySelectorAll("button").forEach((button) => {
    const text = button.textContent.replace(/\s+/g, " ").trim();

    if (/hubungi/i.test(text)) {
      button.addEventListener("click", () => {
        showToast(
          "Kontak belum diatur. Tambahkan nomor WhatsApp atau alamat email resmi.",
        );
      });
      return;
    }

    if (/^(masuk|sign in)$/i.test(text)) {
      button.addEventListener("click", () => {
        showToast("Fitur masuk belum diperlukan untuk situs informasi publik ini.");
      });
      return;
    }

    if (/kembali ke rw 13/i.test(text)) {
      button.addEventListener("click", () => {
        window.location.href = pageUrl("pages/rw-13.html");
      });
      return;
    }

    if (/kembali ke rw 16/i.test(text)) {
      button.addEventListener("click", () => {
        window.location.href = pageUrl("pages/rw-16.html");
      });
      return;
    }

    if (
      /^(visibility\s+)?lihat (leaflet|peta|panduan|poster)/i.test(text) ||
      /^unduh materi/i.test(text) ||
      /^daftarkan anak/i.test(text) ||
      text === "play_arrow"
    ) {
      button.addEventListener("click", () => {
        showToast(
          "Materi atau formulir tujuan belum ditambahkan ke proyek ini.",
        );
      });
    }
  });
})();
