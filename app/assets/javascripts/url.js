/**
 * From:
 * https://stackoverflow.com/questions/22581345/click-button-copy-to-clipboard-using-jquery#30905277
 */
function copyToClipboard(elementId) {

    // Create a "hidden" input
    var aux = document.createElement("input");
  
    // Assign it the value of the specified element
    aux.setAttribute("value", document.getElementById(elementId).innerHTML);
  
    // Append it to the body
    document.body.appendChild(aux);
  
    // Highlight its content
    aux.select();
  
    // Copy the highlighted text
    document.execCommand("copy");
  
    // Remove it from the body
    document.body.removeChild(aux);
  }