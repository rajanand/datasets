var args = require('system').args;
var question_no = args[1]; //console.log(question_no+'.html');

var webPage = require('webpage');
var page = webPage.create();
page.settings.userAgent = 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/538.1 (KHTML, like Gecko) PhantomJS/2.1.1 Safari/538.1 - *** Rajanand Ilangovan (rajanand@outlook.com) - I am trying to collect the list of question and answers posted in rajyasabha website WITHOUT overloading your server. If any concern please contact me.***'; //console.log(page.settings.userAgent);

var fs = require('fs');
var path = question_no+'.html'; 
var url = 'http://164.100.47.5/QSearch/AccessQuestionIpad.aspx?qref='+question_no;

page.open(url, function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();
});

