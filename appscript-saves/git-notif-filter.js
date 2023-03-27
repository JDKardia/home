function archiveGitNotifsThatArentRelevant() {
  const notForMe = GmailApp.search('label:inbox label:Git -label:Git/Me',0,100);
  const forMeButMerged = GmailApp.search('label:inbox label:Git/me Merged into master',0,100);
  GmailApp.moveThreadsToArchive(notForMe.concat(forMeButMerged))
};