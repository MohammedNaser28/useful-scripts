function sendEmailsFromSheet() {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(/*Here Puth sheet name not the names of spreadhseet the sheetname like Sheet1 ..etc; also tom make the speard sheet active go in the spread sheet and select extensions then app scripts to active it */);
  var lastRow = sheet.getLastRow();

  for (var i = 2; i <= lastRow; i++) { // start at row 2 (skip headers)
    var candidateEmail = sheet.getRange(i, 2).getValue(); // Column B
    var finalEmail = sheet.getRange(i, 5).getValue();     // Column E

    if (!finalEmail) continue; // skip empty rows

    // Email subject & body
    var subject = "Interview Invitation";
    var body =
      "Dear Candidate,\n\n" +
      "Congratulations on making it to the second phase. " +
      "In this phase, your suggested plan will be discussed with you.\n\n" +
      "Kindly make sure you attend on time.\n\n" +
      "Best Regards,\n" +
      "OSC'24 President,\n" +
      "Donia Ehab";

    // Send email (to finalEmail, cc candidateEmail if you want)
    MailApp.sendEmail({
      to: finalEmail,
      cc: candidateEmail,
      subject: subject,
      body: body
    });
  }
}
