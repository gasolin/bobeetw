// BoBee 有拜有保庇 — Client-side interactive preferences
// Purely serverless, stores user schedule choices in localStorage locally for privacy.

function selectPraySchedule(pref) {
  localStorage.setItem("bobee-pray-schedule", pref);
  updatePrayUI(pref);
}

function updatePrayUI(pref) {
  const card = document.getElementById("pray-countdown");
  const titleSpan = document.getElementById("pray-title-span");
  const subtitleSpan = document.getElementById("pray-subtitle-span");
  const tab15 = document.getElementById("tab-btn-15");
  const tab16 = document.getElementById("tab-btn-16");
  
  if (!card || !titleSpan || !subtitleSpan) return;
  
  const title15 = card.getAttribute("data-opt-15-title");
  const subtitle15 = card.getAttribute("data-opt-15-subtitle");
  const title16 = card.getAttribute("data-opt-16-title");
  const subtitle16 = card.getAttribute("data-opt-16-subtitle");
  
  // Update Active Tab State
  if (tab15 && tab16) {
    if (pref === "2-16") {
      tab15.classList.remove("active");
      tab16.classList.add("active");
    } else {
      tab16.classList.remove("active");
      tab15.classList.add("active");
    }
  }
  
  // Update Card Text Hierarchy
  if (pref === "2-16") {
    titleSpan.textContent = title16;
    subtitleSpan.textContent = subtitle16;
  } else {
    titleSpan.textContent = title15;
    subtitleSpan.textContent = subtitle15;
  }
}

// Automatically load preferences when DOM is ready
document.addEventListener("DOMContentLoaded", () => {
  const currentPref = localStorage.getItem("bobee-pray-schedule") || "1-15";
  updatePrayUI(currentPref);
});
