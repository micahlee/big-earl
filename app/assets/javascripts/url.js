/**
 * Adapted From:
 * https://stackoverflow.com/questions/22581345/click-button-copy-to-clipboard-using-jquery#30905277
 */
function copyToClipboard(elementId) {

    var aux = document.createElement("input");
    aux.setAttribute("value", document.getElementById(elementId).innerHTML);
    document.body.appendChild(aux);
    aux.select();
    document.execCommand("copy");
    document.body.removeChild(aux);

    var successIndiator = document.getElementById("successIndicator");
    successIndiator.setAttribute("style", "display: inline");
    setTimeout(function() {
      successIndiator.setAttribute("style", "display: none");
    }, 2000);

  }
  