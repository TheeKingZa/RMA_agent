/* animation.js
   (Comment) Handles simple animations and interactions (copy email, reveal on scroll).
*/

/* ---------- Helper: select single element ---------- */
const $ = (sel) => document.querySelector(sel); // (returns: Element | null)

/* ---------- copyEmail: copies the agent email to clipboard ---------- */
function copyEmail() {
  const emailEl = $('#agent-email');
  const email = emailEl ? emailEl.textContent.trim() : '';
  if (!email) {
    alert('Agent email not set. Replace the placeholder in index.html with a real email.');
    return; // (returns: undefined)
  }

  // Use the Clipboard API if available
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(email).then(() => {
      alert('Agent email copied to clipboard: ' + email);
    }).catch(() => {
      fallbackCopy(email);
    });
  } else {
    fallbackCopy(email);
  }

  // (Comment) fallback method uses a temporary textarea
  function fallbackCopy(text) {
    const ta = document.createElement('textarea');
    ta.value = text;
    document.body.appendChild(ta);
    ta.select();
    try {
      document.execCommand('copy');
      alert('Agent email copied to clipboard: ' + text);
    } catch (e) {
      alert('Could not copy automatically. Please copy the email manually: ' + text);
    }
    document.body.removeChild(ta);
    return; // (returns: undefined)
  }
}

/* ---------- revealOnScroll: shows elements with .fade-in when visible ---------- */
function revealOnScroll() {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
      }
    });
  }, { threshold: 0.12 });

  document.querySelectorAll('.fade-in').forEach(el => observer.observe(el));
  return observer; // (returns: IntersectionObserver)
}

/* ---------- init: wire up events and trigger behaviors onload ---------- */
function init() {
  // Attach copy-email action
  const copyBtn = $('#copy-email');
  if (copyBtn) copyBtn.addEventListener('click', copyEmail);

  // Make contact buttons show hover focus easily (no JS needed) and reveal content on scroll
  revealOnScroll();

  // Small hint in console for debugging / editing
  console.log('RMA Agent site loaded. Replace placeholders in index.html with real agent details.');
  return true; // (returns: true)
}

/* Initialize when DOM is ready */
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init);
} else {
  init();
}
