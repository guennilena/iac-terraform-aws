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
