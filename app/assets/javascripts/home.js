// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function submitAddress(event) {
  event.preventDefault()
  console.log($("#address").val());
  window.location.href = "/heatmap?" + $("#address").val();
}
