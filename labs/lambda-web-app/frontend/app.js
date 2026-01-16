async function callApi() {
  try {
    const res = await fetch("/api/health");
    const data = await res.json();
    document.getElementById("out").innerText =
      JSON.stringify(data, null, 2);
  } catch (err) {
    document.getElementById("out").innerText =
      "API call failed: " + err;
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const btn = document.getElementById("btnCallApi");
  if (btn) btn.addEventListener("click", callApi);
});
