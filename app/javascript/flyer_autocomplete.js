document.addEventListener("turbo:load", () => {
  setupAutocomplete({
    inputId: "venue_search",
    resultsId: "venue_results",
    hiddenId: "venue_id",
    searchUrl: "/venues/search"
  });

  setupBandAutocomplete();
});

function setupAutocomplete({ inputId, resultsId, hiddenId, searchUrl }) {
  const input = document.getElementById(inputId);
  const results = document.getElementById(resultsId);
  const hidden = document.getElementById(hiddenId);

  if (!input) return;

  input.addEventListener("input", async () => {
    const q = input.value.trim();
    if (q.length < 1) {
      results.innerHTML = "";
      hidden.value = "";  // Clear hidden field if input is empty
      return;
    }

    const resp = await fetch(`${searchUrl}?q=${encodeURIComponent(q)}`);
    const data = await resp.json();

    results.innerHTML = "";

    // Show existing matches
    data.forEach(item => {
      const div = document.createElement("div");
      div.classList.add("autocomplete-item");
      div.textContent = item.name;
      div.addEventListener("click", () => {
        input.value = item.name;
        hidden.value = item.id;
        results.innerHTML = "";
      });
      results.appendChild(div);
    });

    // If no exact match, show "Create new" option
    const exactMatch = data.find(item => item.name.toLowerCase() === q.toLowerCase());
    if (!exactMatch && q.length > 0) {
      const div = document.createElement("div");
      div.classList.add("autocomplete-item", "create-new");
      div.innerHTML = `<strong>+ Create "${q}"</strong>`;
      div.addEventListener("click", () => {
        input.value = q;
        hidden.value = "";  // Empty means create new
        results.innerHTML = "";
      });
      results.appendChild(div);
    }
  });

  // When input loses focus, if there's text but no ID, it means create new
  input.addEventListener("blur", () => {
    setTimeout(() => {
      results.innerHTML = "";
    }, 200);  // Delay to allow click events to fire
  });
}


function setupBandAutocomplete() {
  const input = document.getElementById("band_search");
  const results = document.getElementById("band_results");
  const selectedList = document.getElementById("selected_bands");
  const hidden = document.getElementById("band_ids_json");

  if (!input) return;

  // Initialize selectedBands from hidden field if editing
  let selectedBands = [];
  try {
    const existingBands = JSON.parse(hidden.value || "[]");
    selectedBands = existingBands;
  } catch (e) {
    selectedBands = [];
  }

  input.addEventListener("input", async () => {
    const q = input.value.trim();
    if (q.length < 1) {
      results.innerHTML = "";
      return;
    }

    const resp = await fetch(`/bands/search?q=${encodeURIComponent(q)}`);
    const data = await resp.json();

    results.innerHTML = "";

    // Show existing matches
    data.forEach(b => {
      const div = document.createElement("div");
      div.classList.add("autocomplete-item");
      div.textContent = b.name;
      div.addEventListener("click", () => {
        addBand(b.id, b.name);
        input.value = "";
        results.innerHTML = "";
      });
      results.appendChild(div);
    });

    // If no exact match, show "Create new" option
    const exactMatch = data.find(b => b.name.toLowerCase() === q.toLowerCase());
    if (!exactMatch && q.length > 0) {
      const div = document.createElement("div");
      div.classList.add("autocomplete-item", "create-new");
      div.innerHTML = `<strong>+ Create "${q}"</strong>`;
      div.addEventListener("click", () => {
        addBand(null, q);  // null id means create new
        input.value = "";
        results.innerHTML = "";
      });
      results.appendChild(div);
    }
  });

  // Handle Enter key to add new band
  input.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      e.preventDefault();
      const q = input.value.trim();
      if (q.length > 0) {
        addBand(null, q);  // null id means create new
        input.value = "";
        results.innerHTML = "";
      }
    }
  });

  function addBand(id, name) {
    // Check if already added (by name for new, by id for existing)
    const exists = id
      ? selectedBands.find(b => b.id === id)
      : selectedBands.find(b => b.name.toLowerCase() === name.toLowerCase());

    if (exists) return;

    selectedBands.push({ id, name });
    hidden.value = JSON.stringify(selectedBands);

    const badge = document.createElement("div");
    badge.className = "badge badge-lg badge-primary gap-2";
    badge.setAttribute("data-band-id", id || "new");
    badge.setAttribute("data-band-name", name);
    badge.innerHTML = `
      ${name}
      <button type="button" class="remove-band">×</button>
    `;

    // Add remove functionality
    badge.querySelector(".remove-band").addEventListener("click", () => {
      selectedBands = selectedBands.filter(b =>
        id ? b.id !== id : b.name !== name
      );
      hidden.value = JSON.stringify(selectedBands);
      badge.remove();
    });

    selectedList.appendChild(badge);
  }

  // Initialize remove buttons for existing bands
  selectedList.querySelectorAll(".remove-band").forEach(btn => {
    btn.addEventListener("click", function() {
      const badge = this.closest("[data-band-id]");
      const bandId = badge.getAttribute("data-band-id");
      selectedBands = selectedBands.filter(b => String(b.id) !== bandId);
      hidden.value = JSON.stringify(selectedBands);
      badge.remove();
    });
  });
}
